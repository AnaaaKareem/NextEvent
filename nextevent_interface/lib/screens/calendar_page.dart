import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/api_service.dart';
import '../models/event.dart';

// Manages stateful calendar page
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Set API service and calendar parameters
  final ApiService _apiService = ApiService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _eventsByDate = {};
  List<Event> _selectedEvents = [];

  // Set initial state
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // Get and map user ticket events
  Future<void> _loadEvents() async {
    final events = await _apiService.fetchUserTickets();

    Map<DateTime, List<Event>> mapped = {};

    // Get event and ticket information
    for (var ticket in events) {
      try {
        final dateStr = ticket['date'] as String;
        final dateOnly = DateTime.parse(dateStr.split("T").first);
        final normalized = DateTime.utc(dateOnly.year, dateOnly.month, dateOnly.day);

        final event = Event(
          id: ticket['event_id'],
          name: ticket['title'],
          description: '',
          location: '',
          budget: 0.0,
          startDate: dateStr,
          endDate: dateStr,
          organizerId: 0,
          type: 'conference',
          status: 'upcoming',
        );

        mapped[normalized] = [...(mapped[normalized] ?? []), event];
      } catch (e) {
        print("❌ Error parsing ticket date: ${ticket['date']} - $e");
      }
    }

    setState(() {
      _eventsByDate = mapped;
      _selectedEvents = _getEventsForDay(_focusedDay);
    });
  }

  // Get events for specific day
  List<Event> _getEventsForDay(DateTime day) {
    final normalized = DateTime.utc(day.year, day.month, day.day);
    return _eventsByDate[normalized] ?? [];
  }

  // Build calendar page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Event Calendar')),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) =>
            _selectedDay != null &&
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day,
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(child: Text("No events this day"))
                : ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.name),
                  subtitle: Text("Date: ${event.startDate}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}