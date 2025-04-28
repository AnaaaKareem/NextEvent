import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Renders ticket page
class TicketPage extends StatelessWidget {
  final Map<String, dynamic> ticket;
  const TicketPage({super.key, required this.ticket});

  // Build ticket page widget
  @override
  Widget build(BuildContext context) {
    final String eventName = ticket['title']?.toString() ?? 'Unknown Event';
    final String qrCode = ticket['qr_code']?.toString() ?? 'N/A';
    final String seat = ticket['seat']?.toString() ?? 'No seat info';
    final String ticketId = ticket['id']?.toString() ?? 'Unknown ID';
    final String date = ticket['date']?.toString().split('T').first ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: Text(eventName)),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.all(30),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QrImageView(
                data: qrCode,
                version: QrVersions.auto,
                size: 300.0,
              ),
              const SizedBox(height: 20),
              Text('📅 $date', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('💺 Seat: $seat', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('🎟️ Ticket ID: $ticketId', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}