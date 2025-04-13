import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Ticket extends StatelessWidget {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 500,
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.all(30),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImageView(data: 'https://findtheinvisiblecow.com/',
            version: QrVersions.auto,
            size: 300.0),
            SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Event Name'),
                  Text('Organizers'),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name: '),
                      Text('Kareem')
                    ],
                  ),
                  Text('Date and Time'),
                  Row(
                    children: [
                      Text('Building '),
                      Text('Twin Towers'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Room '),
                      Text('100'),
                    ],
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