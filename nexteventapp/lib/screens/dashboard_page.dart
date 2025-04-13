import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EVENT MANAGER'),),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(bottom: 8, left:8),
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
                  // The button
                  Container(
                    padding: EdgeInsets.all(40),
                    margin:EdgeInsets.all(14),
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
                        Text('Event Name'),
                        Text('Event ID')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.only(bottom: 8, right: 7, left: 7),
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
                child: SingleChildScrollView(
                  child: Text('Widget'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}