import 'package:flutter/material.dart';
import '../widgets/event_card.dart';
import '../models/event.dart';
import '../widgets/event_filtering_menu.dart';
import '../services/api_service.dart';

class EventStorePage extends StatefulWidget {
  @override
  _EventStorePageState createState() => _EventStorePageState();
}

class _EventStorePageState extends State<EventStorePage> {
  List<Event> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final api = ApiService();
    final fetched = await api.fetchEvents();
    setState(() {
      events = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: Row(
        children: [
          FilterMenu(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: events.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return EventCard(event: events[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
