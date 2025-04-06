import 'package:flutter/material.dart';

// Create Schedule Page
class EventDetailsPage extends StatefulWidget {

  // Create page state
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events Details Page')),
      body: Container(
        // Page
        child: Column(
          children: [
            // Carousel
              Image(
                image: AssetImage('Image1.jpg'),
              fit: BoxFit.fitWidth,),
          ],
        ),
      ),
    );
  }
}