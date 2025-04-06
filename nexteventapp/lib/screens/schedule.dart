import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/booked_event_info.dart';

// Create Schedule Page
class CalendarPage extends StatefulWidget {

  // Create page state
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  // Set default variables for calendar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Calendar Background
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              // Calendar
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
            // Divider
            Container(
                padding: EdgeInsets.all(16),
                child: Divider(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('January 24, 2025', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('N event', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: EventInfo(),
            ),
          ],
        ),
      ),
    );
  }
}