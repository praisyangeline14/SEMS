import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({super.key});

  @override
  State<UsagePage> createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage> {
  String selectedPeriod = "Day";
  String selectedDay = "Monday";

  final Map<String, double> dailyData = {
    "Monday": 2.4,
    "Tuesday": 3.1,
    "Wednesday": 2.8,
    "Thursday": 3.5,
    "Friday": 4.0,
    "Saturday": 3.2,
    "Sunday": 2.7,
  };

  final List<double> weeklyData = [18.5, 22.0, 20.3, 25.0];
  final List<double> monthlyData = [80, 95, 100, 110, 120, 135, 140];

  double get totalEnergy {
    if (selectedPeriod == "Day") {
      return dailyData[selectedDay] ?? 0.0;
    } else if (selectedPeriod == "Week") {
      return weeklyData.reduce((a, b) => a + b);
    } else {
      return monthlyData.reduce((a, b) => a + b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // SAME AS BILL PAGE

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------ TITLE ONLY (NO BACK BUTTON) ------------------
              const Text(
                "Usage Overview",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // ------------------ PERIOD SELECT BUTTONS ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["Day", "Week", "Month"].map((period) {
                  final isSelected = selectedPeriod == period;
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.teal : Colors.white,
                      foregroundColor:
                          isSelected ? Colors.white : Colors.black87,
                      elevation: isSelected ? 3 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.teal
                              : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    child: Text(period),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // ------------------ DAY DROPDOWN ------------------
              if (selectedPeriod == "Day")
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black12.withOpacity(0.07),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedDay,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.teal),
                      items: dailyData.keys
                          .map(
                            (day) => DropdownMenuItem(
                              value: day,
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 28),

              // ------------------ GRAPH CONTAINER ------------------
              Container(
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black12.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${rod.toY.toStringAsFixed(1)} kWh",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              if (selectedPeriod == "Day") {
                                return Text(
                                  selectedDay.substring(0, 3),
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                );
                              } else if (selectedPeriod == "Week") {
                                return Text(
                                  "W${value.toInt() + 1}",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                );
                              } else {
                                return Text(
                                  "M${value.toInt() + 1}",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                );
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "${value.toInt()}",
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 11),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: _buildBarGroups(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ------------------ TOTAL ENERGY CARD ------------------
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black12.withOpacity(0.07),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Energy Consumed",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${totalEnergy.toStringAsFixed(2)} kWh",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    if (selectedPeriod == "Day") return 6;
    if (selectedPeriod == "Week") return 30;
    return 150;
  }

  List<BarChartGroupData> _buildBarGroups() {
    if (selectedPeriod == "Day") {
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: dailyData[selectedDay] ?? 0,
              color: Colors.teal,
              width: 25,
              borderRadius: BorderRadius.circular(6),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxY(),
                // ignore: deprecated_member_use
                color: Colors.teal.shade100.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ];
    }

    if (selectedPeriod == "Week") {
      return weeklyData
          .asMap()
          .entries
          .map(
            (e) => BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  color: Colors.teal,
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: _getMaxY(),
                    // ignore: deprecated_member_use
                    color: Colors.teal.shade100.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          )
          .toList();
    }

    return monthlyData
        .asMap()
        .entries
        .map(
          (e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value,
                color: Colors.teal,
                width: 18,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: _getMaxY(),
                  // ignore: deprecated_member_use
                  color: Colors.teal.shade100.withOpacity(0.3),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
