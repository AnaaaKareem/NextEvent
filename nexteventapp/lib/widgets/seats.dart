import 'package:flutter/material.dart';

class Seats extends StatelessWidget {
  final int rows = 5;
  final int cols = 8;

  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Selected Seats
              Row(
                children: [
                  Text('Selected Seats'),
                  Text('A3, B5')
                ],
              ),
              // Total Price
              Row(
                children: [
                  Text('Total Price'),
                  Text('£32.00')
                ],
              ),
            ],
          ),
          // Booking Button
          SizedBox(
            height: 40,
            width: 500, // set your desired width here
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {},
              child: const Text('Book'),
            ),
          ),
        ],
      ),
    );
  }
}