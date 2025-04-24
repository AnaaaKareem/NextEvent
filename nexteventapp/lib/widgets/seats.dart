import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Seats extends StatefulWidget {
  final int eventId;
  final VoidCallback? onSeatsAdded;

  const Seats({
    super.key,
    required this.eventId,
    this.onSeatsAdded,
  });

  @override
  State<Seats> createState() => _SeatsState();
}

class _SeatsState extends State<Seats> {
  final int rows = 5;
  final int cols = 8;
  Set<String> selectedSeats = {};
  Set<String> takenSeats = {};
  double seatPrice = 16.0;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchTakenSeats();
  }

  Future<void> fetchTakenSeats() async {
    try {
      final result = await apiService.fetchSeats(widget.eventId);
      setState(() {
        takenSeats = Set<String>.from(result);
      });
      print("🎟️ Taken seats: $takenSeats");
    } catch (e) {
      print("❌ Error parsing taken seats: $e");
    }
  }

  void toggleSeat(String seatId) {
    if (takenSeats.contains(seatId)) return;
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        selectedSeats.add(seatId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Select Seats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Row(children: [Icon(Icons.event_seat_rounded, color: Colors.grey), Text('Available')]),
                  Spacer(),
                  Row(children: [Icon(Icons.event_seat_rounded, color: Colors.blue), Text('Selected')]),
                  Spacer(),
                  Row(children: [Icon(Icons.event_seat_rounded, color: Colors.black26), Text('Taken')]),
                ],
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: cols + 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: List.generate((rows + 1) * (cols + 1), (index) {
                  int row = index ~/ (cols + 1);
                  int col = index % (cols + 1);

                  if (row == 0 && col == 0) return Container();
                  if (row == 0) return Center(child: Text(col.toString()));
                  if (col == 0) return Center(child: Text(String.fromCharCode(64 + row)));

                  String seatId = "${String.fromCharCode(64 + row)}$col";
                  bool isTaken = takenSeats.contains(seatId);
                  bool isSelected = selectedSeats.contains(seatId);

                  return GestureDetector(
                    onTap: isTaken ? null : () => toggleSeat(seatId),
                    child: Icon(
                      Icons.event_seat_rounded,
                      color: isTaken
                          ? Colors.black26
                          : isSelected
                              ? Colors.blue
                              : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Seats'),
                      Text(selectedSeats.join(', ')),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Price'),
                      Text('£${(selectedSeats.length * seatPrice).toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () async {
                          final success = await apiService.addSeatsToBasket(
                            eventId: widget.eventId,
                            selectedSeats: selectedSeats.toList(),
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("🧺 Seats added to basket")),
                            );
                            widget.onSeatsAdded?.call();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("❌ Failed to add seats")),
                            );
                          }
                        },
                  child: const Text('Add to Basket'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
