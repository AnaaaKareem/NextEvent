import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/seats.dart';
import 'main_page.dart';
import 'feedback_page.dart';
import 'tickets_page.dart';
import 'event_store_page.dart';
import 'calendar_page.dart';
import 'edit_profile_page.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  final VoidCallback? onPurchaseComplete;

  const EventDetailsPage({
    super.key,
    required this.event,
    this.onPurchaseComplete,
  });

  @override
  EventDetailsPageState createState() => EventDetailsPageState();
}

class EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: Text(event.name)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainPage())),
              title: const Text('Home'),
              leading: Image.asset('assets/home.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventStorePage())),
              title: const Text('Events'),
              leading: Image.asset('assets/calendar.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarPage())),
              title: const Text('Schedule'),
              leading: Image.asset('assets/clock.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketsPage())),
              title: const Text('My Tickets'),
              leading: Image.asset('assets/ticket_home.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage())),
              title: const Text('Feedback'),
              leading: Image.asset('assets/feedback.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage())),
              title: const Text('Settings'),
              leading: Image.asset('assets/settings.png'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.asset('assets/backgtound_one.png', fit: BoxFit.cover),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Event info
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 5),
                            Text('${event.startDate} - ${event.endDate}'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('About this event', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(event.description),
                        const SizedBox(height: 16),
                        const Text('Sub Events', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('SubEvent 1'),
                            Checkbox(value: false, onChanged: null),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset('assets/backgtound_one.png', fit: BoxFit.cover),
                        ),
                        Text(event.location),
                        const Text('Address Details'),
                      ],
                    ),
                  ),
                ),

                // Right side: Seats
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Seats(
                      eventId: event.id,
                      onSeatsAdded: widget.onPurchaseComplete,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
