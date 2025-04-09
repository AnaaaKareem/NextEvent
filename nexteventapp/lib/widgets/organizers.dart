import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventManager extends StatefulWidget {
  const EventManager({super.key});

  @override
  State<EventManager> createState() => _EventManagerState();
}

class _EventManagerState extends State<EventManager> {
  TextEditingController datepicker = TextEditingController();
  TextEditingController timepicker = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        datepicker.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        timepicker.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Add scroll if needed
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('Basic Information'),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Event Name'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Event Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Event Type'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: DropdownMenu(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'music', label: 'Music'),
                            DropdownMenuEntry(value: 'tech', label: 'Technology'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Venue'),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Location'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Location",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Capacity'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Capacity",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Date & Time'),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Date'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          controller: datepicker,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Pick a Date",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Time'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          controller: timepicker,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Pick a Time",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          onTap: () => _selectTime(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Vendors'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: DropdownMenu(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'vendor1', label: 'Abdul'),
                            DropdownMenuEntry(value: 'vendor2', label: 'Seif'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Analyst'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: DropdownMenu(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'analyst1', label: 'Analyst Name'),
                            DropdownMenuEntry(value: 'analyst2', label: 'Analyst Name'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Team Assignment'),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Vendors'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: DropdownMenu(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'vendor1', label: 'Vendor_Name'),
                            DropdownMenuEntry(value: 'vendor2', label: 'Vendor_Name'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Analyst'),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 300.0,
                        child: DropdownMenu(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 'analyst1', label: 'Kareem'),
                            DropdownMenuEntry(value: 'analyst2', label: 'Omar'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {},
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text('Create'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
