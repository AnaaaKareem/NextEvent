import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController sessionNameController = TextEditingController();
  TextEditingController guestController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        timeController.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Organizer Dashboard')),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(left: 8),
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
              child: Column(
                children: [
                  Text('Event List'),
                  // Placeholder for event list / selector
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Event Name #1"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventDetailsCard(),
                  SizedBox(height: 20),
                  _buildItinerarySection(),
                  SizedBox(height: 20),
                  _buildVenueSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: eventTypeController,
              decoration: InputDecoration(labelText: 'Event Type'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Itinerary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: sessionNameController,
              decoration: InputDecoration(labelText: 'Session Name'),
            ),
            TextField(
              controller: guestController,
              decoration: InputDecoration(labelText: 'Guest Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _selectDate,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: _selectTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Add Itinerary'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Venue & Ticket Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: venueController,
              decoration: InputDecoration(labelText: 'Venue Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Auto-create 64 tickets logic goes here
              },
              child: Text('Create Venue & Generate 64 Tickets'),
            ),
          ],
        ),
      ),
    );
  }
}
