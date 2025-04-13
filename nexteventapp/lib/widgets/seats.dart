import 'package:flutter/material.dart';

class Seats extends StatelessWidget {
  final int rows = 5;
  final int cols = 8;

  const Seats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Seats
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // makes Row wrap content tightly
                    children: [
                      Text(
                        'Select Seats',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Seat Selection Guide
                Row(
                  children: [
                    // Available
                    Row(
                      children: [
                        Icon(Icons.event_seat_rounded, color: Colors.white10),
                        Text('Available')
                      ],
                    ),
                    Spacer(flex: 1),
                    // Selected
                    Row(
                      children: [
                        Icon(Icons.event_seat_rounded, color: Colors.lightBlue),
                        Text('Selected')
                      ],
                    ),
                    Spacer(flex: 1),
                    // Taken
                    Row(
                      children: [
                        Icon(Icons.event_seat_rounded, color: Colors.black12),
                        Text('Taken')
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Seat Grid
                GridView.count(
                    crossAxisCount: cols + 1, // extra for row labels
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.2,
                    children: List.generate((rows + 1) * (cols + 1), (index) {
                      int row = index ~/ (cols + 1);
                      int col = index % (cols + 1);

                      if (row == 0 && col == 0) return Container(); // top-left empty

                      if (row == 0) {
                        return Center(child: Text(col.toString())); // Column header
                      }

                      if (col == 0) {
                        return Center(child: Text(String.fromCharCode(64 + row))); // Row label (A, B, C...)
                      }

                      return Icon(Icons.event_seat_rounded, color: Colors.blueAccent);
                    }),
                ),
                // Selected Seats and Total Price
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Selected Seats
                    Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selected Seats'),
                        Text('A3, B5')
                      ],
                    ),
                    // Total Price
                    Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price'),
                        Text('£32.00')
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Booking Button
                SizedBox(
                  height: 40,
                  width: double.infinity, // Makes it fit the width of the screen
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
                    onPressed: () {},
                    child: const Text('Book'),
                  ),
                ),
                SizedBox(height: 10),
                // Stripe Text
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock),
                      SizedBox(width: 8),
                      Text('Secure checkout powered by stripe'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
