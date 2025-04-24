import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = "http://localhost:5000/api";

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

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_type");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<User?> registerUser({
    required String firstName,
    String? middleName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    required String userType,
    String? dateOfBirth,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/register"),
        headers: await _getHeaders(),
        body: jsonEncode({
          "first_name": firstName.trim(),
          "middle_name": middleName?.trim() ?? '',
          "last_name": lastName.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "phone_number": phoneNumber?.trim() ?? '',
          "user_type": userType.trim(),
          "date_of_birth": dateOfBirth?.trim() ?? '',
          "address": address?.trim() ?? '',
        }),
      );

      print("🔹 Register Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        User user = User(
          id: data['user_id'] ?? 0,
          firstName: data['first_name'] ?? '',
          middleName: data['middle_name'] ?? '',
          lastName: data['last_name'] ?? '',
          email: data['email'] ?? '',
          password: '',
          phoneNumber: data['phone_number'] ?? '',
          userType: data['user_type'] ?? '',
          token: data['token'] ?? '',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user.token);
        await prefs.setString("user_type", user.userType);
        await prefs.setInt("userId", user.id);
        await prefs.setString("firstName", user.firstName);
        await prefs.setString("lastName", user.lastName);
        await prefs.setString("email", user.email);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Error registering user: $e");
      return null;
    }
  }

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
        final userData = data['user'];
        User user = User(
          id: userData['user_id'] ?? 0,
          firstName: userData['first_name'] ?? '',
          middleName: userData['middle_name'] ?? '',
          lastName: userData['last_name'] ?? '',
          email: userData['email'] ?? '',
          password: '',
          phoneNumber: userData['phone_number'] ?? '',
          userType: userData['user_type'] ?? '',
          token: data['token'] ?? '',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user.token);
        await prefs.setString("user_type", user.userType);
        await prefs.setInt("userId", user.id);
        await prefs.setString("firstName", user.firstName);
        await prefs.setString("lastName", user.lastName);
        await prefs.setString("email", user.email);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Error logging in: $e");
      return null;
    }
  }

  Future<bool> addSeatsToBasket({
    required int eventId,
    required List<String> selectedSeats,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/basket/add-seats"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "eventId": eventId,
          "selectedSeats": selectedSeats,
        }),
      );

      print("🧺 Add Seats to Basket Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error adding seats to basket: $e");
      return false;
    }
  }

  Future<bool> removeFromBasket(int basketId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/basket/$basketId"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Remove from Basket Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error removing from basket: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBasket() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/basket"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Get Basket Response: ${response.statusCode} - ${response.body}");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error getting basket: $e");
      return [];
    }
  }

  Future<bool> checkoutBasket(List<Map<String, dynamic>> basketItems) async {
  if (basketItems.isEmpty) return false;

  try {
    final token = await getToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final eventId = basketItems[0]['event_id'];
    final selectedSeats = basketItems.map((item) => item['seat'].toString()).toList();
    final quantity = selectedSeats.length;

    final response = await http.post(
      Uri.parse("$_baseUrl/tickets/checkout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
        "event_id": eventId,
        "selectedSeats": selectedSeats,
        "quantity": quantity,
      }),
    );

    print("🧾 Checkout Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final checkoutUrl = data['checkout_url'];
      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
        return true;
      } else {
        print("❌ Cannot launch Stripe checkout URL");
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Error during checkout: $e");
    return false;
  }
}





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

  Future<Map<String, dynamic>?> fetchEventDetails(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/events/$eventId"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Fetch Event Details Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("❌ Error fetching event details: $e");
      return null;
    }
  }

  Future<List<String>> fetchSeats(int eventId) async {
  try {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/seats"),
      headers: await _getHeaders(includeAuth: true),
    );

    print("🔹 Fetch Seats Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      return [];
    }
  } catch (e) {
    print("❌ Error fetching seats: $e");
    return [];
  }
}


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

  Future<bool> createEvent({
    required String eventName,
    required String eventType,
    required String description,
    required String location,
    required double budget,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/events"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "event_name": eventName,
          "event_type": eventType,
          "description": description,
          "location": location,
          "budget": budget,
          "start_date": startDate,
          "end_date": endDate,
        }),
      );

      print("🔹 Create Event Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error creating event: $e");
      return false;
    }
  }

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

  Future<List<Map<String, dynamic>>> fetchItineraries(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/events/$eventId/itineraries"),
        headers: await _getHeaders(includeAuth: true),
      );

      print("🔹 Fetch Itineraries Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching itineraries: $e");
      return [];
    }
  }

  Future<bool> submitFeedback(int itineraryId, int rating, String? comment) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/feedback"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "itinerary_id": itineraryId,
          "rating": rating,
          "comment": comment,
        }),
      );

      print("🔹 Submit Feedback Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error submitting feedback: $e");
      return false;
    }
  }

  Future<bool> createItinerary({
    required int eventId,
    required String sessionName,
    required String sessionDescription,
    required String guest,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/events/$eventId/itineraries"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "session_name": sessionName,
          "session_description": sessionDescription,
          "guest": guest,
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
        }),
      );

      print("🔹 Create Itinerary Response: ${response.statusCode} - ${response.body}");
      return response.statusCode == 201;
    } catch (e) {
      print("❌ Error creating itinerary: $e");
      return false;
    }
  }
}

