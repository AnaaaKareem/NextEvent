import 'package:flutter/material.dart';
import '../widgets/seats.dart';
import 'main_page.dart';
import 'feedback_page.dart';
import 'Tickets_page.dart';
import 'event_store_page.dart';
import 'calendar_page.dart';


class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  EventDetailsPageState createState() => EventDetailsPageState();
}

class EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      drawer: Drawer( // <-- Drawer should be here
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage())
                );
              },
              title: const Text('Home'),
              leading: Image.asset('assets/home.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventStorePage()),);
              },
              title: const Text('Events'),
              leading: Image.asset('assets/calendar.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),);
              },
              title: const Text('Schedule'),
              leading: Image.asset('assets/clock.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TicketsPage()),);
              },
              title: const Text('My Tickets'),
              leading: Image.asset('assets/ticket_home.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),);
              },
              title: const Text('Feedback'),
              leading: Image.asset('assets/feedback.png'),
            ),
            ListTile(
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
            child: Image.asset(
              'assets/backgtound_one.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Name', style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 5),
                            Text('July 15-17, 2025'),
                            SizedBox(width: 10),
                            Icon(Icons.lock_clock),
                            SizedBox(width: 5),
                            Text('6:00 PM - 11:00 PM'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('About this event',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Event Description'),
                        SizedBox(height: 16),
                        Text('Sub Events',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SubEvent 1'),
                            Checkbox(value: false, onChanged: (bool? value) {}),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Location', style: TextStyle(fontWeight: FontWeight
                            .bold)),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset(
                              'assets/backgtound_one.png', fit: BoxFit.cover),
                        ),
                        Text('Main Address'),
                        Text('Address Details'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Seats(),
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