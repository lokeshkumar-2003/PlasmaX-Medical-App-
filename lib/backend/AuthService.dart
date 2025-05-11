import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/pages/ReceiverHomePage.dart';
import 'package:quizapp/backend/SharedPeference.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> handleSignup(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();
        await Sharedpeference.addUserId(user.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Signup successful! Welcome, $username"),
            backgroundColor: Colors.green,
          ),
        );

        await Sharedpeference.clearUserId(); // Clear the stored user ID
        await Sharedpeference.addUserId(user.uid); // Add the new user ID
        Navigator.of(context).pushReplacementNamed("/receiverhome");
      }
      return user?.uid ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("Error at the signup in firebase: $e");
      throw Exception("Signup failed: $e");
    }
  }

  Future<String> handleLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );
        await Sharedpeference.clearUserId(); // Clear the stored user ID
        await Sharedpeference.addUserId(user.uid); // Add the new user ID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReceiverHomePage()),
        );
      }
      return user?.uid ?? '';
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
