import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple.shade300,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _onDone() {
    String message = "Start: ${_formatTime(startTime)} | End: ${_formatTime(endTime)}";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Timer Saved: $message")));
  }

  void _onCancel() {
    setState(() {
      startTime = null;
      endTime = null;
    });
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return "--:--";
    final hour = t.hourOfPeriod.toString().padLeft(2, '0');
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$min $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple.shade100,
        elevation: 0,
        title: const Text(
          "Timer",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _onCancel,
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: _onDone,
            child: const Text("Done",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeBox(
              title: "Set Time",
              time: startTime,
              onTap: () => _selectTime(true),
              color: Colors.blue.shade100,
            ),
            const SizedBox(height: 25),
            _buildTimeBox(
              title: "End Time",
              time: endTime,
              onTap: () => _selectTime(false),
              color: Colors.orange.shade100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox({
    required String title,
    required TimeOfDay? time,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                time != null ? _formatTime(time) : "Select Time",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onTap,
            child: const Text("Set", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
