import 'package:flutter/material.dart';
import '../widgets/ticket_button_card.dart';

// Create Schedule Page
class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});


  // Create page state
  @override
  TicketsPageState createState() => TicketsPageState();
}

class TicketsPageState extends State<TicketsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Calendar Background
            Container(
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
              // Calendar
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TicketInfo(),
                      TicketInfo(),
                      TicketInfo(),
                      TicketInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}