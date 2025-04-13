import 'package:flutter/material.dart';
import 'package:nextevent/screens/analyst_dashboard.dart';
import 'screens/main_page.dart';
// import 'package:nextevent/screens/Tickets_page.dart';
// import 'screens/tickets_page.dart';
// import 'screens/analyst_dashboard.dart';
// import 'screens/dashboard_page.dart';
// import 'screens/feedback_page.dart';
// import 'screens/event_store_page.dart';
// import 'screens/event_details_page.dart';
// import 'screens/calendar_page.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnalystDashboardPage(),
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black
        ),
      ),
    )
  );
}
