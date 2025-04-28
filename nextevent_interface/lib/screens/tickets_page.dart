import 'package:flutter/material.dart';
import '../widgets/event_filtering_menu.dart';
import '../widgets/ticket_card.dart';
import '../services/api_service.dart';
import 'calendar_page.dart';
import 'feedback_page.dart';
import 'event_store_page.dart';
import 'main_page.dart';

// Manages stateful tickets page
class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  // Get user tickets from API
  Future<void> loadTickets() async {
    final fetched = await api.fetchUserTickets();
    setState(() {
      tickets = fetched;
      isLoading = false;
    });
  }

  // Build tickets page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Tickets')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage())),
              title: const Text('Home'),
              leading: Image.asset('assets/home.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventStorePage())),
              title: const Text('Events'),
              leading: Image.asset('assets/calendar.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarPage())),
              title: const Text('Schedule'),
              leading: Image.asset('assets/clock.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketsPage())),
              title: const Text('My Tickets'),
              leading: Image.asset('assets/ticket_home.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbackPage())),
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
          FilterMenu(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: tickets
                    .map((ticket) => TicketCard(ticket: ticket))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}