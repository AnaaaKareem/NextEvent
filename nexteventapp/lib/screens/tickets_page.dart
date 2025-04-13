import 'package:flutter/material.dart';
import '../widgets/event_filtering_menu.dart';
import '../widgets/ticket_card.dart';
import 'calendar_page.dart';
import 'feedback_page.dart';
import 'event_store_page.dart';
import 'main_page.dart';

class TicketsPage extends StatefulWidget {
  @override
  _EventStorePageState createState() => _EventStorePageState();
}

class _EventStorePageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>MainPage())
                  );

                },
                title: const Text('Home'),
                leading: Image.asset('assets/home.png'),
              ),
              ListTile(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EventStorePage()),);
                },
                title: const Text('Events'),
                leading: Image.asset('assets/calendar.png'),
              ),
              ListTile(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CalendarPage()),);
                },
                title: const Text('Schedule'),
                leading: Image.asset('assets/clock.png'),
              ),
              ListTile(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TicketsPage()),);
                },
                title: const Text('My Tickets'),
                leading: Image.asset('assets/ticket_home.png'),
              ),
              ListTile(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedbackPage()),);
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
      body: Row(
        children: [
          FilterMenu(), // Fixed left panel
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(12, (index) => TicketCard()),
              ),

            ),
          ),
        ],
      ),
    );
  }
}