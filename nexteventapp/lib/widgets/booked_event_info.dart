import 'package:flutter/material.dart';

class EventInfo extends StatelessWidget {
  const EventInfo({super.key});


  @override
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
                    color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(100), // Makes it rounded like a capsule
                ),
                child: Text(
                  'Conference',
                  style: TextStyle(
                    color: Colors.blue.shade700,
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
              Row(
                children: [
                  Icon(Icons.business_rounded),
                  Text('Event Location')
                ],
              ),
              // Venue
              Row(
                children: [
                  Icon(Icons.meeting_room_rounded),
                  Text('Event Venue')
                ],
              ),
              // Dates
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded),
                  Text('Event Date')
                ],
              ),
              // Time
              // Dates
              Row(
                children: [
                  Icon(Icons.access_time),
                  Text('Event Time(s)')
                ],
              ),
              SizedBox(height: 80,),

            ],
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Annual technology conference featuring keynote speakers, workshops, and networking opportunities.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}