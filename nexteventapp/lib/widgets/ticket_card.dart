import 'package:flutter/material.dart';
import '../screens/event_details_page.dart';
// import '../screens/DashboardPage.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key}); // Constructor with key

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(

            height: 150,
            width: double.infinity,
            child: Image.asset(
              'assets/Analytics.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8),

          // Event title
          Text(
            'Event Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),

          // Date & time row
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Mar 15-17, 2025 • 9:00AM - 6:00PM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Conventional Center, New York',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Price and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '£168',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF2B43E1),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetailsPage()),);
                },
                child: Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
