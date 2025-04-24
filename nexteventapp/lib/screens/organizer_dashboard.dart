import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class OrganizerDashboard extends StatefulWidget {
  final User user;

  const OrganizerDashboard({super.key, required this.user});

  @override
  _OrganizerDashboardState createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String _selectedType = 'conference';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

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

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = picked.toIso8601String().split("T")[0];
    }
  }

  Future<void> _createEvent() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ All fields are required")),
      );
      return;
    }

    final success = await _apiService.createEvent(
      eventName: _nameController.text.trim(),
      eventType: _selectedType,
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      budget: double.tryParse(_budgetController.text.trim()) ?? 0.0,
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
    );

    if (success) {
      Navigator.pop(context);
      _fetchEvents();
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Event created")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to create event")),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _budgetController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _selectedType = "conference";
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organizer Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
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
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Event"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Event Name"),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: const [
                    DropdownMenuItem(value: "conference", child: Text("Conference")),
                    DropdownMenuItem(value: "workshop", child: Text("Workshop")),
                    DropdownMenuItem(value: "concert", child: Text("Concert")),
                    DropdownMenuItem(value: "festival", child: Text("Festival")),
                  ],
                  onChanged: (value) => setState(() => _selectedType = value!),
                  decoration: const InputDecoration(labelText: "Event Type"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Budget"),
                ),
                TextField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "Start Date"),
                  onTap: () => _pickDate(_startDateController),
                ),
                TextField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: "End Date"),
                  onTap: () => _pickDate(_endDateController),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _createEvent,
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
