import 'package:flutter/material.dart';
import '../models/event.dart';

// Builds event details widget
class EventInfo extends StatelessWidget {
  final Event event;

  const EventInfo({super.key, required this.event});

  // Build event information card widget
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  event.type,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(Icons.business_rounded), SizedBox(width: 5), Text(event.location)]),
              Row(children: [Icon(Icons.calendar_today_rounded), SizedBox(width: 5), Text("${event.startDate} - ${event.endDate}")]),
              Row(children: [Icon(Icons.access_time), SizedBox(width: 5), Text("All Day")]),
            ],
          ),
          SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(event.description,
                style: TextStyle(fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }
}