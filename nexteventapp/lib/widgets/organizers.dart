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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic Information'),
            Row(
              children: [
                _buildTextFieldColumn('Event Name', 'Event Name'),
                _buildDropdownColumn('Event Type', [
                  DropdownMenuEntry(value: 'music', label: 'Music'),
                  DropdownMenuEntry(value: 'tech', label: 'Technology'),
                ]),
              ],
            ),
            const Text('Venue'),
            Row(
              children: [
                _buildTextFieldColumn('Location', 'Location'),
                _buildTextFieldColumn('Capacity', 'Capacity'),
              ],
            ),
            const Text('Date & Time'),
            Row(
              children: [
                _buildDatePickerField('Date', datepicker, () => _selectDate(context)),
                _buildDatePickerField('Time', timepicker, () => _selectTime(context)),
              ],
            ),
            Row(
              children: [
                _buildDropdownColumn('Vendors', [
                  DropdownMenuEntry(value: 'vendor1', label: 'Abdul'),
                  DropdownMenuEntry(value: 'vendor2', label: 'Seif'),
                ]),
                _buildDropdownColumn('Analyst', [
                  DropdownMenuEntry(value: 'analyst1', label: 'Analyst Name'),
                  DropdownMenuEntry(value: 'analyst2', label: 'Analyst Name'),
                ]),
              ],
            ),
            const Text('Team Assignment'),
            Row(
              children: [
                _buildDropdownColumn('Vendors', [
                  DropdownMenuEntry(value: 'vendor1', label: 'Vendor_Name'),
                  DropdownMenuEntry(value: 'vendor2', label: 'Vendor_Name'),
                ]),
                _buildDropdownColumn('Analyst', [
                  DropdownMenuEntry(value: 'analyst1', label: 'Kareem'),
                  DropdownMenuEntry(value: 'analyst2', label: 'Omar'),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldColumn(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(label),
          SizedBox(
            width: 300.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownColumn(String label, List<DropdownMenuEntry> entries) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(label),
          SizedBox(
            width: 300.0,
            child: DropdownMenu(dropdownMenuEntries: entries),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(label),
          SizedBox(
            width: 300.0,
            child: TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Pick a $label",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(label == "Date" ? Icons.calendar_today : Icons.access_time),
              ),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class Vendor extends StatelessWidget {
  const Vendor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ticket Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Create and manage your event tickets'),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.money),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Revenue'),
                              Text('\$12345'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.money),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Total Sold'),
                              Text('1234'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Event', style: TextStyle(fontStyle: FontStyle.italic))),
                DataColumn(label: Text('Price', style: TextStyle(fontStyle: FontStyle.italic))),
                DataColumn(label: Text('Amount Sold', style: TextStyle(fontStyle: FontStyle.italic))),
                DataColumn(label: Text('Settings', style: TextStyle(fontStyle: FontStyle.italic))),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Concert A')),
                  DataCell(Text('\$25')),
                  DataCell(Text('150')),
                  DataCell(Icon(Icons.settings)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Festival B')),
                  DataCell(Text('\$40')),
                  DataCell(Text('300')),
                  DataCell(Icon(Icons.settings)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Seminar C')),
                  DataCell(Text('\$10')),
                  DataCell(Text('75')),
                  DataCell(Icon(Icons.settings)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Seminar C')),
                  DataCell(Text('\$10')),
                  DataCell(Text('75')),
                  DataCell(Icon(Icons.settings)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
