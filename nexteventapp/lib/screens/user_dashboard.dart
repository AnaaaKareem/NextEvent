import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'event_details_page.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class UserDashboard extends StatefulWidget {
  final User user;

  const UserDashboard({super.key, required this.user});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoadingEvents = true;
  bool _isLoadingTickets = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _fetchUserTickets();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchUserTickets();
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _apiService.fetchEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingEvents = false);
    }
  }

  Future<void> _fetchUserTickets() async {
    try {
      final tickets = await _apiService.fetchUserTickets();
      if (mounted) {
        setState(() {
          _tickets = tickets.map((t) => {
                "id": t["id"],
                "event_id": t["event_id"],
                "title": t["title"],
                "date": t["date"],
                "qr_code": t["qr_code"],
              }).toList();
          _isLoadingTickets = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingTickets = false);
    }
  }

  bool _hasTicket(int eventId) {
    return _tickets.any((ticket) => ticket["event_id"] == eventId);
  }

  Widget _buildEventList() {
    if (_isLoadingEvents) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_events.isEmpty) {
      return const Center(child: Text("📅 No events available", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        final bool hasTicket = _hasTicket(event.id);

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${event.startDate} - ${event.endDate}"),
            trailing: hasTicket ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsPage(
                  event: event,
                  onPurchaseComplete: _fetchUserTickets, // ✅ Fix
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicketSection() {
    if (_isLoadingTickets) {
      return const Center(child: CircularProgressIndicator());
    }
    return _tickets.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("🎟 You have no tickets yet", style: TextStyle(color: Colors.grey)),
          )
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("🎟 Your Tickets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ..._tickets.map((ticket) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.event, color: Colors.blue),
                      title: Text(ticket["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ticket["date"]),
                          const SizedBox(height: 5),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QrImageView(
                                data: ticket["qr_code"],
                                version: QrVersions.auto,
                                size: 120.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Dashboard")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTicketSection(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
}
