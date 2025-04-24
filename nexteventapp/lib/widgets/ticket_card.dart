import 'package:flutter/material.dart';
import 'ticket.dart';

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final eventName = ticket['title']?.toString() ?? 'Unknown Event';
    final startDate = ticket['date']?.toString().split('T').first ?? 'Unknown Date';
    final qrCode = ticket['qr_code']?.toString() ?? 'N/A';
    final seat = ticket['seat']?.toString() ?? 'N/A';
    final status = ticket['status']?.toString() ?? 'not scanned';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TicketPage(ticket: ticket)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.asset(
                'assets/Analytics.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              eventName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(
                  startDate,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.event_seat, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Seat: $seat",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR: $qrCode',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  status == 'scanned' ? 'Scanned' : 'Not Scanned',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: status == 'scanned' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
