import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalystDashboardPage extends StatelessWidget {
  const AnalystDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Event Analyst',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Analytics'),
              leading: Icon(Icons.analytics),
              onTap: () => print('Analytics tapped!'),
            ),
            ListTile(
              title: const Text('Create Ticket'),
              leading: Icon(Icons.confirmation_number),
              onTap: () => print('Create Ticket tapped!'),
            ),
            ListTile(
              title: const Text('Create Event'),
              leading: Icon(Icons.event),
              onTap: () => print('Create Event tapped!'),
            ),
            ListTile(
              title: const Text('Ticket Management'),
              leading: Icon(Icons.manage_accounts),
              onTap: () => print('Ticket Management tapped!'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: cards('Total Revenue', '\$124,563', Icons.attach_money, Colors.green, '12.5% vs last month', Colors.green)),
                Expanded(child: cards('Tickets Sold', '1,432', Icons.confirmation_number, Colors.purple, '6.2% vs last month', Colors.purple)),
                Expanded(child: cards('Check-in Rate', '85.4%', Icons.check_circle, Colors.blue, '3.1% vs last month', Colors.blue)),
                Expanded(child: cards('Satisfaction Rate', '4.8/5', Icons.star, Colors.orange, '0.3 vs last month', Colors.orange)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: chart1("Ticket Sales Analysis")),
                Expanded(child: chart2("Venue & Capacity Analysis")),

              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: chart3("Attendance Analysis")),
                Expanded(child: feedbackChart(20, 30)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cards(String title, String value, IconData icon, Color iconColor, String comparison, Color comparisonColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
                CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.1),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.arrow_upward, color: comparisonColor, size: 16),
                SizedBox(width: 4),
                Text(comparison, style: TextStyle(fontSize: 12, color: comparisonColor)),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget chart1(String title) => Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1: return Text('Conversion\n68%', textAlign: TextAlign.center);
                          case 2: return Text('Discount\n24%', textAlign: TextAlign.center);
                          case 3: return Text('Growth\n12%', textAlign: TextAlign.center);
                          default: return SizedBox.shrink();
                        }
                      },
                      reservedSize: 50,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8,color: Colors.blue)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10 ,color:  Colors.blueAccent)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 14, color: Colors.lightBlue)]),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Widget chart2(String title) => Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1: return Text('Top Performing Venue', textAlign: TextAlign.center);
                          case 2: return Text('Avg. Occupancy Rate', textAlign: TextAlign.center);
                          default: return SizedBox.shrink();
                        }
                      },
                      reservedSize: 50,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8,color: Colors.deepPurpleAccent)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10,color: Colors.purple)]),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget chart3(String title) => Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1: return Text('Check-in Rate', textAlign: TextAlign.center);
                          case 2: return Text('No-show Rate', textAlign: TextAlign.center);
                          case 3: return Text('Peak Attendance', textAlign: TextAlign.center);

                          default: return SizedBox.shrink();
                        }
                      },
                      reservedSize: 50,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8,color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10,color: Colors.red)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6,color: Colors.orange)]),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Widget feedbackChart(int satisfaction, int dissatisfaction) => Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feedback & Satisfaction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: satisfaction.toDouble(),
                    title: '${satisfaction}%\nSatisfied',
                    radius: 60,
                    color: Colors.green,
                    titlePositionPercentageOffset: 0.55,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: dissatisfaction.toDouble(),
                    title: '${dissatisfaction}%\nDissatisfied',
                    radius: 60,
                    color: Colors.red,
                    titlePositionPercentageOffset: 0.55,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}