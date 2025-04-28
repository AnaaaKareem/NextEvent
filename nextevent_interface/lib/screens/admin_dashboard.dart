import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../services/api_service.dart';

// Manages stateful admin dashboard UI
class AdminDashboard extends StatefulWidget {
  final User user;

  const AdminDashboard({super.key, required this.user});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Get events from API
  Future<void> _fetchEvents() async {
    try {
      final events = await _apiService.fetchEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      print("❌ Error fetching events: $e");
    }
  }

  // Delete event and refresh list
  Future<void> _deleteEvent(int eventId) async {
    bool success = await _apiService.deleteEvent(eventId);
    if (success) {
      _fetchEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Event deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to delete event")),
      );
    }
  }

  // Build admin dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: _events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(event.date),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteEvent(event.id),
              ),
            ),
          );
        },
      ),
    );
  }
}