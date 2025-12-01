import 'package:flutter/material.dart';

class BillOverviewPage extends StatefulWidget {
  const BillOverviewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BillOverviewPageState createState() => _BillOverviewPageState();
}

class _BillOverviewPageState extends State<BillOverviewPage> {
  String selectedView = 'Day';
  final TextEditingController _budgetController = TextEditingController();

  final Map<String, dynamic> billData = {
    "Day": {
      "Total Current": "2.86 kW",
      "Total Voltage": "1.5 V",
      "Total Frequency": "5.4 Hz",
      "Per Unit Current": "1.5 ₹",
      "Total Cost": "250 ₹",
    },
    "Week": {
      "Week 1": "₹240",
      "Week 2": "₹260",
      "Week 3": "₹280",
      "Week 4": "₹230",
    },
    "Month": {
      "January": "₹1000",
      "February": "₹950",
      "March": "₹1100",
    },
  };

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Widget _buildFilterButton(String type) {
    final bool isSelected = selectedView == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedView = type;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.blueAccent.shade100),
            ),
            elevation: isSelected ? 4 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            type,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildBillSection() {
    if (selectedView == 'Day') {
      final data = billData['Day'] as Map<String, String>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(entry.value,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )
            .toList(),
      );
    } else {
      final data = billData[selectedView] as Map<String, String>;
      return Column(
        children: data.entries
            .map(
              (e) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  e.key,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  e.value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            )
            .toList(),
      );
    }
  }

  void _saveBudget() {
    final budget = _budgetController.text.trim();
    if (budget.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a budget amount.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Budget of ₹$budget saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE ONLY (NO BACK ARROW)
                const Text(
                  "Bill Overview",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildFilterButton('Day'),
                    _buildFilterButton('Week'),
                    _buildFilterButton('Month'),
                  ],
                ),

                const SizedBox(height: 22),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: _buildBillSection(),
                ),

                const SizedBox(height: 20),

                if (selectedView == 'Day')
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.blueAccent.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Total Cost",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Text("₹250",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                const SizedBox(height: 26),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Set Monthly Budget",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter your budget (₹)",
                          prefixIcon: const Icon(Icons.currency_rupee),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _saveBudget,
                        icon:
                            const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          "Save Budget",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize:
                              const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
