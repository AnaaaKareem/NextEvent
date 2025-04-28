import 'package:flutter/material.dart';

// Builds ticket info card
class TicketInfo extends StatelessWidget {
  const TicketInfo({super.key});

  // Build ticket info card widget
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
          Text('Sub event - Event', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold)),
          Text('Date & Time'),
        ],
      ),
    );
  }
}