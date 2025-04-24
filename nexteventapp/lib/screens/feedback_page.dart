import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import 'main_page.dart';
import 'calendar_page.dart';
import 'event_store_page.dart';
import 'tickets_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final ApiService _apiService = ApiService();

  List<Event> events = [];
  List<Map<String, dynamic>> itineraries = [];

  Event? selectedEvent;
  Map<String, dynamic>? selectedItinerary;

  double rating = 0;
  TextEditingController commentController = TextEditingController();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final data = await _apiService.fetchEvents();
    setState(() {
      events = data;
    });
  }

  Future<void> fetchItineraries(int eventId) async {
    final data = await _apiService.fetchItineraries(eventId);
    setState(() {
      itineraries = data;
    });
  }

  Future<void> submitFeedback() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating")),
      );
      return;
    }

    if (selectedItinerary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a subevent (or choose None)")),
      );
      return;
    }

    setState(() => isSubmitting = true);
    final success = await _apiService.submitFeedback(
      selectedItinerary!['itinerary_id'],
      rating.toInt(),
      commentController.text.trim().isNotEmpty ? commentController.text.trim() : null,
    );
    setState(() => isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Feedback submitted")));
      commentController.clear();
      setState(() {
        selectedEvent = null;
        selectedItinerary = null;
        rating = 0;
        itineraries = [];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Failed to submit feedback")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Page')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainPage())),
              title: const Text('Home'),
              leading: Image.asset('assets/home.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventStorePage())),
              title: const Text('Events'),
              leading: Image.asset('assets/calendar.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarPage())),
              title: const Text('Schedule'),
              leading: Image.asset('assets/clock.png'),
            ),
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketsPage())),
              title: const Text('My Tickets'),
              leading: Image.asset('assets/ticket_home.png'),
            ),
            ListTile(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Column(
              children: [
                Image.asset('assets/calendar.png', height: 100, width: 100),
                const Text('Share your thoughts ', style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
          const SizedBox(height: 50),
          const Divider(thickness: 2, color: Colors.grey),

          const Text('Select Event'),
          DropdownButton<Event>(
            isExpanded: true,
            hint: const Text('Choose Event'),
            value: selectedEvent,
            items: events.map((event) {
              return DropdownMenuItem(
                value: event,
                child: Text(event.name),
              );
            }).toList(),
            onChanged: (Event? value) {
              setState(() {
                selectedEvent = value;
                selectedItinerary = null;
              });
              fetchItineraries(value!.id);
            },
          ),

          const SizedBox(height: 10),
          const Text('Select SubEvent'),
          DropdownButton<Map<String, dynamic>?>(
            isExpanded: true,
            hint: const Text('Choose SubEvent'),
            value: selectedItinerary,
            items: [
              const DropdownMenuItem<Map<String, dynamic>?>(
                value: null,
                child: Text('None'),
              ),
              ...itineraries.map((subEvent) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: subEvent,
                  child: Text(subEvent['session_name']),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                selectedItinerary = value;
              });
            },
          ),

          const SizedBox(height: 20),
          const Text('Rating'),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            maxRating: 5,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (r) => setState(() => rating = r),
          ),

          const SizedBox(height: 20),
          const Text('Comment'),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your feedback...',
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: isSubmitting ? null : submitFeedback,
              child: Text(isSubmitting ? "Submitting..." : "Submit Feedback"),
            ),
          ),
        ]),
      ),
    );
  }
}
