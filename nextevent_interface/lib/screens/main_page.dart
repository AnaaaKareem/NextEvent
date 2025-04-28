import 'package:flutter/material.dart';
import '../models/user.dart';
import 'calendar_page.dart';
import 'event_store_page.dart';
import 'feedback_page.dart';
import 'tickets_page.dart';
import 'basket_page.dart';
import 'edit_profile_page.dart';

// Manages stateful main page
class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, this.user});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool light = true;

  // Build main page
  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Next Event - Welcome ${user.firstName}' : 'Next Event'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_basket_outlined),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BasketPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
          Switch(
            value: light,
            activeColor: Colors.black,
            onChanged: (bool value) {
              setState(() {
                light = value;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage(user: user)));
              },
              title: const Text('Home'),
              leading: Image.asset('assets/home.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventStorePage()));
              },
              title: const Text('Events'),
              leading: Image.asset('assets/calendar.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
              title: const Text('Schedule'),
              leading: Image.asset('assets/clock.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TicketsPage()));
              },
              title: const Text('My Tickets'),
              leading: Image.asset('assets/ticket_home.png'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
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
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          children: [
            _buildGridCard(
              label: "Events",
              subLabel: "Browse Events",
              image: "Image1.jpg",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventStorePage())),
            ),
            _buildGridCard(
              label: "Schedule",
              subLabel: "Browse Schedule",
              image: "Image1.jpg",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarPage())),
            ),
            _buildGridCard(
              label: "Tickets",
              subLabel: "Browse Tickets",
              image: "Image1.jpg",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TicketsPage())),
            ),
            _buildGridCard(
              label: "Feedback",
              subLabel: "Provide Feedback",
              image: "Image1.jpg",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackPage())),
            ),
          ],
        ),
      ),
    );
  }

  // Build navigation grid card
  Widget _buildGridCard({
    required String label,
    required String subLabel,
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                Text(label, style: const TextStyle(color: Colors.white)),
                Row(
                  children: [
                    const Icon(Icons.arrow_right_alt, color: Colors.white),
                    Text(subLabel, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}