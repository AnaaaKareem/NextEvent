import 'package:flutter/material.dart';

class SeatSelector extends StatefulWidget {
  final Function(List<String>) onSeatsSelected;
  final List<String> takenSeats; // ✅ new parameter for already booked seats

  const SeatSelector({
    super.key,
    required this.onSeatsSelected,
    required this.takenSeats,
  });

  @override
  State<SeatSelector> createState() => _SeatSelectorState();
}

class _SeatSelectorState extends State<SeatSelector> {
  List<String> selectedSeats = [];
  final List<String> seatLabels = List.generate(5 * 8, (index) {
    final row = String.fromCharCode(65 + index ~/ 8); // A-E
    final col = (index % 8) + 1;
    return '$row$col';
  });

  void toggleSeat(String seat) {
    if (widget.takenSeats.contains(seat)) return; // ❌ Don't allow selecting taken seats
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
    widget.onSeatsSelected(selectedSeats);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seatLabels.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1.2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final seat = seatLabels[index];
        final isSelected = selectedSeats.contains(seat);
        final isTaken = widget.takenSeats.contains(seat);

        Color bgColor;
        if (isTaken) {
          bgColor = Colors.black26; // ⚫ taken seat
        } else if (isSelected) {
          bgColor = Colors.green; // ✅ selected seat
        } else {
          bgColor = Colors.grey.shade300; // ⚪ available
        }

        return GestureDetector(
          onTap: () => toggleSeat(seat),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
            child: Text(
              seat,
              style: TextStyle(
                color: isTaken ? Colors.white70 : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
