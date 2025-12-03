import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // ------------------- Custom responsive time picker dialog -------------------
  Future<TimeOfDay?> _showCustomTimePicker() async {
    int hour = 7;
    int minute = 15;
    bool isAm = true;

    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        // constrain dialog size so it won't overflow on small screens
        return LayoutBuilder(builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.7;
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: StatefulBuilder(builder: (context, setStateDialog) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // title aligned left
                    children: [
                      const Text(
                        "ENTER TIME",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // time controls row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _numberBox(
                            value: hour,
                            label: "Hour",
                            onIncrease: () {
                              setStateDialog(() {
                                hour = hour == 12 ? 1 : hour + 1;
                              });
                            },
                            onDecrease: () {
                              setStateDialog(() {
                                hour = hour == 1 ? 12 : hour - 1;
                              });
                            },
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(":", style: TextStyle(fontSize: 34)),
                          ),

                          _numberBox(
                            value: minute,
                            label: "Minute",
                            onIncrease: () {
                              setStateDialog(() {
                                minute = (minute + 1) % 60;
                              });
                            },
                            onDecrease: () {
                              setStateDialog(() {
                                minute = (minute - 1) < 0 ? 59 : minute - 1;
                              });
                            },
                          ),

                          const SizedBox(width: 18),

                          // AM/PM vertical toggle
                          Column(
                            children: [
                              _amPmButton("AM", isAm, () {
                                setStateDialog(() => isAm = true);
                              }),
                              const SizedBox(height: 6),
                              _amPmButton("PM", !isAm, () {
                                setStateDialog(() => isAm = false);
                              }),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // buttons (right aligned)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 18),
                            ),
                            onPressed: () {
                              final int finalHour =
                                  isAm ? (hour % 12) : ((hour % 12) + 12);
                              selectedTime =
                                  TimeOfDay(hour: finalHour, minute: minute);
                              Navigator.pop(dialogCtx);
                            },
                            child: const Text("OK",
                                style: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        });
      },
    );

    return selectedTime;
  }

  // wrapper used by page buttons
  Future<void> _selectTime(bool isStart) async {
    final picked = await _showCustomTimePicker();
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

  // ------------------- Page action handlers -------------------
  void _onDone() {
    String message =
        "Start: ${_formatTime(startTime)} | End: ${_formatTime(endTime)}";
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

  // ------------------- Build UI -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // match other pages: blue-ish background
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade100, // BLUE THEME
        elevation: 0,
        centerTitle:
            false, // ensure title is left aligned like Bill page (important)
        title: const Text(
          "Timer",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          // CANCEL as a formal text button (right side)
          TextButton(
            onPressed: _onCancel,
            child: const Text("Cancel",
                style: TextStyle(color: Colors.red, fontSize: 15)),
          ),
          // DONE formal button
          TextButton(
            onPressed: _onDone,
            child: const Text("Done",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Use SingleChildScrollView to avoid overflow when vertical space is limited
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            _buildTimeBox(
              title: "Set Time",
              time: startTime,
              onTap: () => _selectTime(true),
              color: Colors.blue.shade100,
            ),
            const SizedBox(height: 20),
            _buildTimeBox(
              title: "End Time",
              time: endTime,
              onTap: () => _selectTime(false),
              color: Colors.blue.shade100, // keep consistent blue
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ------------------- Time box widget -------------------
  Widget _buildTimeBox({
    required String title,
    required TimeOfDay? time,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                time != null ? _formatTime(time) : "Select Time",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),

          // Set button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // match page theme
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            onPressed: onTap,
            child: const Text("Set", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ------------------- Dialog helper widgets -------------------
  Widget _numberBox({
    required int value,
    required String label,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // up
              GestureDetector(
                onTap: onIncrease,
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.keyboard_arrow_up, size: 28),
                ),
              ),

              // value
              Text(
                value.toString().padLeft(2, '0'),
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              // down
              GestureDetector(
                onTap: onDecrease,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.keyboard_arrow_down, size: 28),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _amPmButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
