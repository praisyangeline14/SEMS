import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  double totalEnergy = 6.86;
  double mainPhaseEnergy = 2.29;
  double temperature = 15.0;
  double frequency = 5.4;
  double voltage = 2.80;
  double current = 2.29;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],   // SAME AS BILL PAGE

      appBar: AppBar(
        backgroundColor: Colors.blue[50], // SAME BILL PAGE APPBAR STYLE
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          "Overview",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWhiteCard(
              title: "Total Energy Consumed",
              value: "$totalEnergy kWh",
            ),

            const SizedBox(height: 18),

            _buildWhiteCard(
              title: "Energy Consumed at Main",
              subtitle: "Main Phase",
              value: "$mainPhaseEnergy kW",
            ),

            const SizedBox(height: 25),

            const Text(
              "Today's Readings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            _buildReadingsCard(),
          ],
        ),
      ),
    );
  }

  // ================= WHITE CARDS LIKE BILL PAGE =================
  Widget _buildWhiteCard({
    required String title,
    String? subtitle,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 7,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }

  // ================= READINGS CARD (MATCHING BILL PAGE STYLE) ================
  Widget _buildReadingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 7,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildReadingRow("Temperature", "$temperature °C"),
          const Divider(),
          _buildReadingRow("Frequency", "$frequency Hz"),
          const Divider(),
          _buildReadingRow("Voltage", "$voltage V"),
          const Divider(),
          _buildReadingRow("Current", "$current W"),
        ],
      ),
    );
  }

  Widget _buildReadingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
