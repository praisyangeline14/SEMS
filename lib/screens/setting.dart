import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  bool notificationsMuted = false;
  String muteDuration = "None"; // None, 1 Hour, 1 Day

  void showMuteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Mute Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text("Unmute"),
                onTap: () {
                  setState(() {
                    muteDuration = "None";
                    notificationsMuted = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Mute for 1 Hour"),
                onTap: () {
                  setState(() {
                    muteDuration = "1 Hour";
                    notificationsMuted = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Mute for 1 Day"),
                onTap: () {
                  setState(() {
                    muteDuration = "1 Day";
                    notificationsMuted = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EnergyHomePage()),
        );
        return false; // prevent default back action
      }, 
      child: Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green,
      ),

      body: ListView(
        children: [
          // PROFILE SECTION
          buildSectionTitle("Profile"),
          buildTile(
            icon: Icons.account_circle,
            title: "Account",
            subtitle: "Name, Email, Profile Picture",
            onTap: () {},
          ),

          // SECURITY SECTION
          buildSectionTitle("Security"),
          buildTile(
            icon: Icons.lock,
            title: "App Lock",
            subtitle: "Enable / Disable App Lock",
            onTap: () {},
          ),
          buildTile(
            icon: Icons.password,
            title: "Change Password",
            onTap: () {},
          ),
          buildTile(
            icon: Icons.shield,
            title: "Set New Password",
            onTap: () {},
          ),

          // APPEARANCE
          buildSectionTitle("Appearance"),
          buildTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),

          // NOTIFICATION SETTINGS
          buildSectionTitle("Notifications"),
          buildTile(
            icon: Icons.notifications,
            title: "Mute Notifications",
            subtitle: "Current: $muteDuration",
            onTap: showMuteOptions,
          ),

          // SUPPORT & HELP
          buildSectionTitle("Support"),
          buildTile(
            icon: Icons.help,
            title: "Help & Support",
            onTap: () {},
          ),
          buildTile(
            icon: Icons.info,
            title: "App Version",
            subtitle: "v1.0.0",
          ),

          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}
