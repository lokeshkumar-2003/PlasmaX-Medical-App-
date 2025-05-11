import 'package:flutter/material.dart';
import 'package:quizapp/components/Loader.dart';
import 'package:quizapp/components/Login.dart';
import 'package:quizapp/components/Signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isLoading = false;

  void handleAuthPage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Loader()
            : isLogin
                ? Login(
                    onSwitchToSignup: handleAuthPage,
                  )
                : Signup(onSwitchToLogin: handleAuthPage),
      ),
    );
  }
}
