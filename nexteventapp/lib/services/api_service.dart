import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // 🔹 Needed for opening Stripe URL
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = "http://192.168.1.27:5000/api";

  // 🔹 Helper: Get headers (Include Auth Token)
  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {"Content-Type": "application/json"};
    if (includeAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  // 🔹 Fetch Events (All Users)
  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/events"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Fetch Events Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Event.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching events: $e");
      return [];
    }
  }

  // 🔹 Create Event (Only for Organizers/Admins)
  Future<bool> createEvent(String title, String description, String date, String location) async {
    if ([title, description, date, location].any((field) => field.trim().isEmpty)) {
      print("❌ Error: Missing event details");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/events"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "title": title.trim(),
          "description": description.trim(),
          "date": date.trim(),
          "location": location.trim(),
        }),
      );

      print("🔹 Create Event Response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error creating event: $e");
      return false;
    }
  }

  // 🔹 Delete Event (Admin Only)
  Future<bool> deleteEvent(int eventId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/events/$eventId"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Delete Event Response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error deleting event: $e");
      return false;
    }
  }

  // 🔹 Purchase Single Ticket (Stripe Checkout)
  Future<bool> purchaseTicket(int eventId) async {
    return await purchaseMultipleTickets(eventId, 1);
  }

  // 🔹 Purchase Multiple Tickets via Stripe
  Future<bool> purchaseMultipleTickets(int eventId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/tickets/checkout"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "event_id": eventId,
          "quantity": quantity, // ✅ Send quantity
        }),
      );

      print("🔹 Purchase Tickets Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Ensure checkout_url exists
        if (!data.containsKey("checkout_url") || data["checkout_url"] == null || data["checkout_url"].toString().isEmpty) {
          print("❌ Error: Missing checkout URL in response");
          return false;
        }

        final String checkoutUrl = data["checkout_url"];
        Uri url = Uri.parse(checkoutUrl);

        // ✅ Open Stripe Checkout in external browser
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          print("❌ Cannot open Stripe Checkout URL");
          return false;
        }

        return true;
      } else {
        print("❌ Failed to purchase tickets: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error purchasing tickets: $e");
      return false;
    }
  }

  // 🔹 Fetch User Tickets
  Future<List<Map<String, dynamic>>> fetchUserTickets() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/tickets"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Fetch Tickets Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching tickets: $e");
      return [];
    }
  }

  // 🔹 Register User (With Role Validation)
  Future<bool> registerUser(String name, String email, String password, String role) async {
    if ([name, email, password, role].any((field) => field.trim().isEmpty)) {
      print("❌ Error: Missing registration fields");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/register"),
        headers: await _getHeaders(),
        body: jsonEncode({
          "name": name.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "role": role.trim()
        }),
      );

      print("🔹 Register Response: ${response.statusCode} - ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error registering user: $e");
      return false;
    }
  }

  // 🔹 Login User (Stores Token & Role)
  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        headers: await _getHeaders(),
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      print("🔹 Login Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        User user = User(
          id: data["userId"] ?? 0,
          name: data["name"] ?? "Unknown",
          email: data["email"] ?? "No Email",
          role: data["role"] ?? "user",
          token: data["token"] ?? "",
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user.token);
        await prefs.setString("role", user.role);
        await prefs.setInt("userId", user.id);
        await prefs.setString("name", user.name);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Error logging in: $e");
      return null;
    }
  }

  // 🔹 Get Stored Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // 🔹 Get User Role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  // 🔹 Logout (Clears stored token & role)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("role");
    await prefs.remove("userId");
  }
}