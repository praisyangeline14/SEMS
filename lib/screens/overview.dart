// import 'package:flutter/material.dart';

// class OverviewPage extends StatefulWidget {
//   const OverviewPage({super.key});

//   @override
//   State<OverviewPage> createState() => _OverviewPageState();
// }

// class _OverviewPageState extends State<OverviewPage> {
//   double perUnitCurrent = 0;
//   double timestamp = 0;    
//   double totalCost = 0;
//   double totalCurrent = 0;
//   double totalFrequency = 0;
//   double totalVoltage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],   // SAME AS BILL PAGE

//       appBar: AppBar(
//         backgroundColor: Colors.blue[50], // SAME BILL PAGE APPBAR STYLE
//         elevation: 0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "Overview",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildWhiteCard(
//               title: "Total Energy Consumed",
//               value: "$perUnitCurrent kWh",
//             ),

//             const SizedBox(height: 18),

//             _buildWhiteCard(
//               title: "Energy Consumed at Main",
//               subtitle: "Main Phase",
//               value: "$timestamp kW",
//             ),

//             const SizedBox(height: 25),

//             const Text(
//               "Today's Readings",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black87,
//               ),
//             ),

//             const SizedBox(height: 12),

//             _buildReadingsCard(),
//           ],
//         ),
//       ),
      
//     );
//   }

//   // ================= WHITE CARDS LIKE BILL PAGE =================
//   Widget _buildWhiteCard({
//     required String title,
//     String? subtitle,
//     required String value,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 7,
//             offset: const Offset(2, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (subtitle != null)
//             Text(
//               subtitle,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black54,
//               ),
//             ),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // ================= READINGS CARD (MATCHING BILL PAGE STYLE) ================
//   Widget _buildReadingsCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 7,
//             offset: const Offset(2, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildReadingRow("Temperature", "$totalCost °C"),
//           const Divider(),
//           _buildReadingRow("Frequency", "$totalCurrent Hz"),
//           const Divider(),
//           _buildReadingRow("Voltage", "$totalFrequency V"),
//           const Divider(),
//           _buildReadingRow("Current", "$totalVoltage W"),
//         ],
//       ),
//     );
//   }

//   Widget _buildReadingRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {

  // 🔥 Firestore document ID
  final String docId = "ESP32_1";

  double power = 0;
  double totalCurrent = 0;
  String relay = "";
  double voltage = 0;
  // double totalCost = 0;
  DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],

      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0,
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

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Usage_measures")
            .doc(docId)
            .snapshots(),
        builder: (context, snapshot) {

          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ No data
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data available"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // ✅ Read Firestore data safely
          totalCurrent = (data['current'] ?? 0).toDouble();
            power = (data['power'] ?? 0).toDouble();
          relay   = (data['relay'] ?? 0).toString();
          voltage = (data['voltage'] ?? 0).toDouble();
          // totalCost      = (data['totalCost'] ?? 0).toDouble();
          timestamp =(data['timestamp'] != null)
              ? (data['timestamp'] as Timestamp).toDate()
              : null;

          final Timestamp? ts = data['timestamp'];
          timestamp = ts?.toDate();

          return _buildUI();
        },
      ),
    );
  }

  // ================= MAIN UI =================
  Widget _buildUI() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildWhiteCard(
            title: "Total Energy Consumed",
            value: "${power.toStringAsFixed(2)} kWh",
          ),

          const SizedBox(height: 18),

          _buildWhiteCard(
            title: "Energy Consumed at Main",
            subtitle: "Main Phase",
            value: "${totalCurrent.toStringAsFixed(2)} kW",
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
    );
  }

  // ================= WHITE CARD =================
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
          ),
        ],
      ),
    );
  }

  // ================= READINGS CARD =================
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
          _buildReadingRow("Current", "$totalCurrent A"),
          const Divider(),
          _buildReadingRow("relay", "$relay "),
          const Divider(),
          _buildReadingRow("Voltage", "$voltage V"),
          const Divider(),
          // _buildReadingRow("Current", "$totalCurrent A"),
          // const Divider(),
          _buildReadingRow("timestamp", "$timestamp"),
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
