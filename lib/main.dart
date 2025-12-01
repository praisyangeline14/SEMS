import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/screens/bill.dart';
import 'package:flutter_application_1/screens/menu.dart';
import 'package:flutter_application_1/screens/overview.dart';
import 'package:flutter_application_1/screens/timer.dart';
import 'package:flutter_application_1/screens/usage.dart';
import 'package:intl/intl.dart';

void main() => runApp(const EnergyApp());

class EnergyApp extends StatelessWidget {
  const EnergyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Energy Dashboard',

      // ✅ GLOBAL THEME FOR ENTIRE APP
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        cardTheme: CardThemeData(
  color: Colors.white,
  elevation: 3,
  shadowColor: Colors.black26,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
),


        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
          headlineSmall: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.deepPurple,
          size: 26,
        ),
      ),

      home: const EnergyHomePage(),
    );
  }
}

// ----------------------------------------------------------------------

class EnergyHomePage extends StatefulWidget {
  const EnergyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EnergyHomePageState createState() => _EnergyHomePageState();
}

class _EnergyHomePageState extends State<EnergyHomePage> {
  DateTime selectedDate = DateTime.now();
  List<double> hourlyUsage =
      List.generate(24, (i) => (Random().nextDouble() * 4) + 0.5);

  double get totalToday => hourlyUsage.fold(0.0, (a, b) => a + b);

  void refreshData() {
    setState(() {
      hourlyUsage = List.generate(
        24,
        (i) => double.parse(((Random().nextDouble() * 4) + 0.5).toStringAsFixed(2)),
      );
    });
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hourlyUsage = List.generate(
          24,
          (i) => double.parse(((Random().nextDouble() * 4) + 0.5).toStringAsFixed(2)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, d MMM yyyy').format(selectedDate);

    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ------------------ TOP BAR ------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconButton(Icons.home, () {}),

                    const Text(
                      "Home Page",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuDrawer(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ------------------ DATE + REFRESH ------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today Usage",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          dateLabel,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          onPressed: pickDate,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 18),
                          onPressed: refreshData,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ------------------ GRAPH CARD ------------------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 220,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: hourlyUsage.reduce((a, b) => a > b ? a : b) * 1.4,
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 6,
                                    getTitlesWidget: (value, meta) {
                                      return Text("${value.toInt()}h",
                                          style: const TextStyle(fontSize: 10));
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) =>
                                        Text(value.toStringAsFixed(0),
                                            style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(
                                show: true,
                                horizontalInterval: 1,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                      hourlyUsage.length,
                                      (i) => FlSpot(i.toDouble(), hourlyUsage[i])),
                                  isCurved: true,
                                  dotData: FlDotData(show: false),
                                  color: Colors.deepPurple,
                                  barWidth: 3,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        // ignore: deprecated_member_use
                                        Colors.deepPurple.withOpacity(0.3),
                                        // ignore: deprecated_member_use
                                        Colors.deepPurple.withOpacity(0.05)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Energy used Today",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${totalToday.toStringAsFixed(2)} kWh",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ------------------ GRID BUTTONS ------------------
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _buildGridButton(
                      title: "Bill",
                      icon: Icons.receipt_long,
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillOverviewPage(),
                          ),
                        );
                      },
                    ),

                    _buildGridButton(
                      title: "Overview",
                      icon: Icons.list_alt,
                      color: const Color.fromARGB(255, 0, 150, 136),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OverviewPage(),
                          ),
                        );
                      },
                    ),

                    _buildGridButton(
                      title: "Timer",
                      icon: Icons.timer,
                      color: Colors.pinkAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerPage(),
                          ),
                        );
                      },
                    ),

                    _buildGridButton(
                      title: "Usage",
                      icon: Icons.show_chart,
                      color: Colors.lightBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsagePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ ICON BUTTON ------------------
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
    );
  }

  // ------------------ GRID BUTTON ------------------
  Widget _buildGridButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap to open",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
