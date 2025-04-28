import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = "http://localhost:5000/api";

  // Get request headers
  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {"Content-Type": "application/json"};
    // Check if authentication is true
    if (includeAuth) {
      // Get token
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_type");
  }

  // Clear user session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Register new user
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
      // Send user register information
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

      // Check if registration is successful
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

        // Store user information
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user.token);
        await prefs.setString("user_type", user.userType);
        await prefs.setInt("userId", user.id);
        await prefs.setString("firstName", user.firstName);
        await prefs.setString("lastName", user.lastName);
        await prefs.setString("email", user.email);

        // Return user data
        return user;
      } else {
        return null;
      }
    } catch (e) {
      // Return null on error catch
      return null;
    }
  }

  // Log in user
  Future<User?> loginUser(String email, String password) async {
    try {
      // Send log in request
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        headers: await _getHeaders(),
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      // Check if login is successful
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

        // Store user information
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user.token);
        await prefs.setString("user_type", user.userType);
        await prefs.setInt("userId", user.id);
        await prefs.setString("firstName", user.firstName);
        await prefs.setString("lastName", user.lastName);
        await prefs.setString("email", user.email);

        // Return user data
        return user;
      } else {
        // Return null
        return null;
      }
    } catch (e) {
      // Return null on error catch
      return null;
    }
  }

  // Add seats to user basket
  Future<bool> addSeatsToBasket({
    required int eventId,
    required List<String> selectedSeats,
  }) async {
    try {
      // Send request to add seats
      final response = await http.post(
        Uri.parse("$_baseUrl/basket/add-seats"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "eventId": eventId,
          "selectedSeats": selectedSeats,
        }),
      );

      // Return a success status
      return response.statusCode == 200;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Remove ticket from basket
  Future<bool> removeFromBasket(int basketId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/basket/$basketId"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Return a success status
      return response.statusCode == 200;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Get tickets from the user's basket
  Future<List<Map<String, dynamic>>> getBasket() async {
    try {
      // Send request to get basket
      final response = await http.get(
        Uri.parse("$_baseUrl/basket"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        // Return tickets
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        // Return empty list
        return [];
      }
    } catch (e) {
      // Return empty list on error catch
      return [];
    }
  }

  // Process checkout
  Future<bool> checkoutBasket(List<Map<String, dynamic>> basketItems) async {
    // Check if basket is empty
    if (basketItems.isEmpty) {
      return false;
    }

    try {
      // Get user and basket details
      final token = await getToken();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final eventId = basketItems[0]['event_id'];
      final selectedSeats = basketItems.map((item) => item['seat'].toString()).toList();
      final quantity = selectedSeats.length;

      // Send checkout request
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

      // Check if checkout is successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['checkout_url'];
        // Launch Stripe checkout
        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
          return true;
        } else {
          // Return false if url is invalid
          return false;
        }
      } else {
        // Return false if status is not successful
        return false;
      }
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Get all events
  Future<List<Event>> fetchEvents() async {
    try {
      // Send request to get events
      final response = await http.get(
        Uri.parse("$_baseUrl/events"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Event.fromJson(json)).toList();
      } else {
        // Return an empty list
        return [];
      }
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  // Get event details
  Future<Map<String, dynamic>?> fetchEventDetails(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/events/$eventId"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Return null
        return null;
      }
    } catch (e) {
      // Return null on error catch
      return null;
    }
  }

  // Get seats for an event
  Future<List<String>> fetchSeats(int eventId) async {
  try {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/seats"),
      headers: await _getHeaders(includeAuth: true),
    );

    // Check if request is successful
    if (response.statusCode == 200) {
      // Return seats list for an event
      return List<String>.from(jsonDecode(response.body));
    } else {
      // Return an empty list
      return [];
    }
  } catch (e) {
    // Return empty list on error catch
    return [];
  }
}

  // Get user tickets
  Future<List<Map<String, dynamic>>> fetchUserTickets() async {
    try {
      // Send request to get tickets
      final response = await http.get(
        Uri.parse("$_baseUrl/tickets"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        // Return a list of tickets
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        // Return an empty list
        return [];
      }
    } catch (e) {
      // Return an empty list on error catch
      return [];
    }
  }

  // Create new event
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
      // Send request to create event
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

      // Return success status
      return response.statusCode == 201;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Delete an event
  Future<bool> deleteEvent(int eventId) async {
    try {
      // Send request to delete event
      final response = await http.delete(
        Uri.parse("$_baseUrl/events/$eventId"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Return success status
      return response.statusCode == 200;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Get itineraries from a specific event
  Future<List<Map<String, dynamic>>> fetchItineraries(int eventId) async {
    try {
      // Send request to get itineraries
      final response = await http.get(
        Uri.parse("$_baseUrl/events/$eventId/itineraries"),
        headers: await _getHeaders(includeAuth: true),
      );

      // Check if request is successful
      if (response.statusCode == 200) {
        // Return list of itineraries
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        // Return an empty list
        return [];
      }
    } catch (e) {
      // Return an empty list on error catch
      return [];
    }
  }

  // Create new itinerary
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
      // Send request to create itinerary
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

      // Return success status
      return response.statusCode == 201;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }

  // Submit feedback for itinerary
  Future<bool> submitFeedback(int itineraryId, int rating, String? comment) async {
    try {
      // Send request to submit feedback
      final response = await http.post(
        Uri.parse("$_baseUrl/feedback"),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          "itinerary_id": itineraryId,
          "rating": rating,
          "comment": comment,
        }),
      );

      // Return success status
      return response.statusCode == 200;
    } catch (e) {
      // Return false on error catch
      return false;
    }
  }
}