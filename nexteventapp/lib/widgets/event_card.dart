import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with fixed height
          Image.asset(
            'Image1.jpg',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          // Event name
          Text(
            'Event Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          // Event date and time
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 8),
              Text(
                'Mar 15-17, 2025 • 9:00AM - 6:00PM',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Event location
          Row(
            children: [
              Icon(Icons.location_on, size: 18),
              SizedBox(width: 8),
              Text(
                'Conventional Center, New York',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Price and Details button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '£168',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {},
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
