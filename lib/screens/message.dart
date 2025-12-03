import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

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
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xfff2f6ff),  // bill page theme
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
        description:
            "If this usage continues, you may exceed your monthly budget.",
        time: "Today, 08:00 AM"),
    Message(
        title: "Budget Alert",
        description: "You have used 80% of your 20-day energy budget.",
        time: "Yesterday, 07:45 PM"),
    Message(
        title: "Usage Reminder",
        description:
            "Consider reducing consumption to stay within your monthly limit.",
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
      messages.removeWhere(
          (msg) => selectedIndexes.contains(messages.indexOf(msg)));
      selectedIndexes.clear();
      selectionMode = false;
    });
  }

  void shareSelected() {
    String text = selectedIndexes
        .map((i) =>
            "${messages[i].title}\n${messages[i].description}\n${messages[i].time}")
        .join("\n\n");
    // ignore: deprecated_member_use
    Share.share(text);
  }

  void copySelected() {
    String copiedText = selectedIndexes
        .map((i) =>
            "${messages[i].title}\n${messages[i].description}\n${messages[i].time}")
        .join("\n\n");

    Clipboard.setData(ClipboardData(text: copiedText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Message copied")),
    );
  }

  void openMessage(Message msg) {
    msg.read = true;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(message: msg),
      ),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EnergyHomePage()),
        );
        return false; // prevent default back action
      },
   child:  Scaffold(
      appBar: AppBar(
        title: Text(selectionMode
            ? "${selectedIndexes.length} selected"
            : "Messages"),
        actions: selectionMode
            ? [
                IconButton(
                    onPressed: selectAll,
                    icon: const Icon(Icons.done_all)), // NEW modern icon
                IconButton(
                    onPressed: copySelected,
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: shareSelected,
                    icon: const Icon(Icons.share)),
                IconButton(
                    onPressed: deleteSelected,
                    icon: const Icon(Icons.delete)),
              ]
            : null,
      ),
      body: messages.isEmpty
          ? const Center(
              child: Text("No messages",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                      openMessage(msg);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          // ignore: deprecated_member_use
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.transparent,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 1.5,
                      child: ListTile(
                        leading: Icon(
                          msg.title.contains('Alert')
                              ? Icons.warning_amber_rounded
                              : Icons.bolt,
                          color: msg.title.contains('Alert')
                              ? Colors.red
                              : Colors.blue,
                        ),
                        title: Text(
                          msg.title,
                          style: TextStyle(
                            fontWeight: msg.read
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msg.description),
                              const SizedBox(height: 4),
                              Text(
                                msg.time,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                );
              },
            ),
    ));
  }
}

//---------------- DETAIL PAGE ----------------//

class MessageDetailPage extends StatelessWidget {
  final Message message;

  const MessageDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.description,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(message.time,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//---------------- MODEL ----------------//

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
