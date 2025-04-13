import 'package:flutter/material.dart';
import '../widgets/event_card.dart';
import '../widgets/event_filtering_menu.dart'; // Import your FilterMenu here

class EventStorePage extends StatefulWidget {
  @override
  _EventStorePageState createState() => _EventStorePageState();
}

class _EventStorePageState extends State<EventStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
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
                  children: List.generate(12, (index) => EventCard()),
                ),

            ),
          ),
        ],
      ),
    );


  }
}