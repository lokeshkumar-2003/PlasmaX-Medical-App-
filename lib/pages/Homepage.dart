import 'package:flutter/material.dart';
import 'package:quizapp/backend/AuthService.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthService _authservice = AuthService();
  String username = "guest";
  @override
  void initState() {
    super.initState();
    handleGetDetails();
  }

  void handleGetDetails() async {
    final user = _authservice.getCurrentUser();
    print("Home: $user");
    if (user != null) {
      setState(() {
        username = user.displayName ?? "guest";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: Center(
        child: Text(
          "Hello, $username",
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
