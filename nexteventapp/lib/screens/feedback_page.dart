import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'main_page.dart';
import 'calendar_page.dart';
import 'event_store_page.dart';
import 'tickets_page.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Page')),
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
      body: SingleChildScrollView(
          child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/calendar.png',height: 100, // replace with desired height
                    width: 100,),
                  const Text('Share your thoughts ',style: TextStyle( fontSize: 30),)
                ],
              ),
            ),

            SizedBox(height: 50),
            Divider( // we use Divider for make a line
              thickness: 2,
              color: Colors.grey,
            ),

            const Text('Select Event'),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose Event'),
              items: [],
              onChanged: null,
            ),
            const SizedBox(height: 10),
            const Text('Select SubEvent'),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose SubEvent'),
              items: [],
              onChanged: null,
            ),
            const SizedBox(height: 20),
            const Text('Rating'),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(height: 20),
            const Text('Comment'),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your feedback...',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: null,
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}