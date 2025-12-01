import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Messages',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MessagePage(),
    );
  }
}

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [
    Message(
        title: "Budget Alert",
        description: "You have used 65% of your 10-day energy budget.",
        time: "Today, 09:30 AM"),
    Message(
        title: "Usage Warning",
        description: "If this usage continues, you may exceed your monthly budget.",
        time: "Today, 08:00 AM"),
    Message(
        title: "Budget Alert",
        description: "You have used 80% of your 20-day energy budget.",
        time: "Yesterday, 07:45 PM"),
    Message(
        title: "Usage Reminder",
        description: "Consider reducing consumption to stay within your monthly limit.",
        time: "Yesterday, 06:15 PM"),
  ];

  bool selectionMode = false;
  Set<int> selectedIndexes = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
        if (selectedIndexes.isEmpty) selectionMode = false;
      } else {
        selectedIndexes.add(index);
        selectionMode = true;
      }
    });
  }

  void selectAll() {
    setState(() {
      selectedIndexes = messages.asMap().keys.toSet();
    });
  }

  void deleteSelected() {
    setState(() {
      messages.removeWhere((msg) => selectedIndexes.contains(messages.indexOf(msg)));
      selectedIndexes.clear();
      selectionMode = false;
    });
  }

  void shareSelected() {
    String text = selectedIndexes
        .map((i) => "${messages[i].title}\n${messages[i].description}\n${messages[i].time}")
        .join("\n\n");
    // ignore: deprecated_member_use
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectionMode ? "${selectedIndexes.length} selected" : "Energy Messages"),
        backgroundColor: Colors.green,
        actions: selectionMode
            ? [
                IconButton(onPressed: selectAll, icon: const Icon(Icons.select_all)),
                IconButton(onPressed: shareSelected, icon: const Icon(Icons.share)),
                IconButton(onPressed: deleteSelected, icon: const Icon(Icons.delete)),
              ]
            : null,
      ),
      body: messages.isEmpty
          ? const Center(
              child: Text(
                "No messages",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isSelected = selectedIndexes.contains(index);
                return GestureDetector(
                  onLongPress: () => toggleSelection(index),
                  onTap: () {
                    if (selectionMode) {
                      toggleSelection(index);
                    } else {
                      setState(() {
                        msg.read = true;
                      });
                    }
                  },
                  child: Container(
                    // ignore: deprecated_member_use
                    color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          msg.title.contains('Alert') ? Icons.warning_amber_rounded : Icons.lightbulb,
                          color: msg.title.contains('Alert') ? Colors.red : Colors.orange,
                        ),
                        title: Text(
                          msg.title,
                          style: TextStyle(
                            fontWeight: msg.read ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg.description),
                            const SizedBox(height: 4),
                            Text(
                              msg.time,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: !selectionMode
                            ? IconButton(
                                icon: const Icon(Icons.share, color: Colors.blue),
                                onPressed: () {
                                  // ignore: deprecated_member_use
                                  Share.share("${msg.title}\n${msg.description}\n${msg.time}");
                                },
                              )
                            : null,
                        isThreeLine: true,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Message {
  String title;
  String description;
  String time;
  bool read;

  Message({
    required this.title,
    required this.description,
    required this.time,
    this.read = false,
  });
}
