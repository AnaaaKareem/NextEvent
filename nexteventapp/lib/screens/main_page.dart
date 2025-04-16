import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'event_store_page.dart';
import 'feedback_page.dart';
import 'tickets_page.dart';

// Create Schedule Page
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Event'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          Switch(value: light,
              activeColor: Colors.black,
              onChanged: (bool value) {
                setState(() {
                  light=value;
                });
              })
        ],
      ),
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
      body: Center(
        child: Column(

          mainAxisSize: MainAxisSize.max,
          children: [

            GridView.count(

              crossAxisCount: 2,
              childAspectRatio: 2.5,
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventStorePage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(

                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(

                          image: DecorationImage(

                            image: AssetImage('Image1.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [

                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Events',
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Browse Events',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('Image1.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule',
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Browse Schedule',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TicketsPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('Image1.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tickets',
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Browse Tickets',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('Image1.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Positioned(

                        bottom: 20,
                        left: 20,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(

                              'Feedback',
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Provide Feedback',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}