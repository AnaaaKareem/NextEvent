import 'package:flutter/material.dart';

class EventInfo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // First Row Event Name and Event Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  // Event Name
                  Text('Event Name', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                  // Event Type
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adds padding inside the capsule
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color of the capsule
                        borderRadius: BorderRadius.circular(30), // Makes it rounded like a capsule
                      ),
                      child: Text(
                        'Conference',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 14, // Text size
                        ),
                      ),
                    ),
                ],
          ),
          // Event Location, Venue, Date, Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location
              Column(
                children: [
                  Icon(Icons.business_rounded),
                  Text('Event Location')
                ],
              ),
              // Venue
              Column(
                children: [
                  Icon(Icons.meeting_room_rounded),
                  Text('Event Venue')
                ],
              ),
              // Dates
              Column(
                children: [
                  Icon(Icons.calendar_today_rounded),
                  Text('Event Date')
                ],
              ),
              // Time
              // Dates
              Column(
                children: [
                  Icon(Icons.access_time),
                  Text('Event Time(s)')
                ],
              ),
            ],
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Event Description'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}