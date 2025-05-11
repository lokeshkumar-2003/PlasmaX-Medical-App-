import 'package:flutter/material.dart';
import 'package:quizapp/backend/SharedPeference.dart';

class FlyoutNavbarDemo extends StatelessWidget {
  const FlyoutNavbarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flyout Navbar"),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: FlyoutNavbar(),
      body: Center(
        child: Text("Home Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class FlyoutNavbar extends StatelessWidget {
  const FlyoutNavbar({super.key});

  Future<void> logout(BuildContext context) async {
    await Sharedpeference.clearUserId();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/auth',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// **Header with User Info**
          UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/profile.jpg"), // Add an image in assets folder
            ),
            decoration: BoxDecoration(color: Colors.redAccent),
          ),

          /// **Navigation Items**
          ListTile(
            leading: Icon(Icons.home, color: Colors.redAccent),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text("Notifications"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.green),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          /// **Logout Button**
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logged Out!")),
              );
            },
          ),
        ],
      ),
    );
  }
}
