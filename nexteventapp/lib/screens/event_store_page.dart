import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class EventStorePage extends StatefulWidget {
  const EventStorePage({super.key});

  @override
  EventStorePageState createState() => EventStorePageState();
}

class EventStorePageState extends State<EventStorePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
            children: [
              EventCard(),
              EventCard(),
              EventCard(),
              EventCard(),
            ],
            ),
          ],
        ),
      ),
    );
  }
}