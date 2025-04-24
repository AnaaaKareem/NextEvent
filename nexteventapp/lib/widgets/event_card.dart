import 'package:flutter/material.dart';
import '../models/event.dart';
import '../screens/event_details_page.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onPurchaseComplete; // ✅ New callback parameter

  const EventCard({
    super.key,
    required this.event,
    this.onPurchaseComplete, // ✅ Store callback
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.bar_chart, size: 80, color: Colors.teal),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16),
                    const SizedBox(width: 4),
                    Text(event.startDate),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(event.location),
                  ],
                ),
                const SizedBox(height: 4),
                Text("£${event.budget.toStringAsFixed(2)}", style: const TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsPage(
                        event: event,
                        onPurchaseComplete: onPurchaseComplete, // ✅ Pass callback to details page
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Book"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
