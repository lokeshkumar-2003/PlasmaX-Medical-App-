import 'package:flutter/material.dart';
import 'package:quizapp/backend/AuthService.dart';

class Login extends StatefulWidget {
  final VoidCallback onSwitchToSignup;

  const Login({required this.onSwitchToSignup, super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authservice = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true; // Show loader
    });

    print("🔵 Login started");

    try {
      String userId = await _authservice.handleLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );

      if (!mounted) return;

      // Navigate to Home Page
      Navigator.pushReplacementNamed(
        context,
        "/donorhome",
      );
    } catch (e) {
      if (!mounted) return;

      print("🔴 Login failed: ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign in",
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Image.asset(
                  "assets/images/login_img.png",
                  height: 250.0,
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Please login to your account",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 30.0),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                // Login Button with Loader
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _handleLogin, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 30.0),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you new here? ",
                      style: TextStyle(fontSize: 16.0, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: widget.onSwitchToSignup,
                      child: const Text(
                        "register",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
