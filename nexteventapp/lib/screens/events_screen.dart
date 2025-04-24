import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Event>> events;

  @override
  void initState() {
    super.initState();
    events = apiService.fetchEvents();
  }

  // ✅ Refresh events after a ticket purchase
  void _refreshEvents() {
    setState(() {
      events = apiService.fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: FutureBuilder<List<Event>>(
        future: events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return EventCard(
                  event: snapshot.data![index],
                  onPurchaseComplete: _refreshEvents, // ✅ Fix: Pass callback to refresh events
                );
              },
            );
          }
        },
      ),
    );
  }
}
