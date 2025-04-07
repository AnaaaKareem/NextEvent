import 'package:flutter/material.dart';
import '../widgets/seats.dart';

class EventDetailsPage extends StatefulWidget {
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Full-width Image
          SizedBox(
            width: double.infinity,
            height: 200, // adjust height as needed
            child: Image.asset(
              'Image1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Body layout split into Seats and Event Info
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
                        Text('Event Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                        Text('About this event', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Event Description'),
                        SizedBox(height: 16),

                        Text('Sub Events', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SubEvent 1'),
                            Checkbox(value: false, onChanged: (bool? value) {}),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.asset('Image1.jpg', fit: BoxFit.cover),
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
