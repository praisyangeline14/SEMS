import 'package:flutter/material.dart';

// -------------------- MENU DRAWER --------------------
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, this.isLoggedIn = false});

  // Simulated login status for testing
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------- HEADER --------------------
          UserAccountsDrawerHeader(
            accountName: Text(isLoggedIn ? "John Doe" : "Guest User"),
            accountEmail: Text(isLoggedIn ? "johndoe@example.com" : "Not logged in"),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),

          // -------------------- USER PROFILE --------------------
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Profile"),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfilePage(),
                ),
              );
            },
          ),

          // -------------------- LOGIN --------------------
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),

          // -------------------- LOGOUT --------------------
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                // Simulate logout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
              },
            ),

          const Spacer(),

          // -------------------- FOOTER --------------------
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Smart Energy Meter v1.0",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- USER PROFILE PAGE --------------------
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated user info
    const userName = "John Doe";
    const userEmail = "johndoe@example.com";

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Name: $userName",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              "Email: $userEmail",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- LOGIN PAGE --------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: const Center(
        child: Text("This is the Login Page"),
      ),
    );
  }
}
