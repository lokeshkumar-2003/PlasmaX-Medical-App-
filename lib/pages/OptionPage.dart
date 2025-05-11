import 'package:flutter/material.dart';
import 'package:quizapp/pages/receiversection/ReceiverOptionPage.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8BFBF), // Light Pink Background
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Plasma X",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Smart banking, zero worries.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Donate ", // Make "Donate" larger
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 28,
                              fontWeight: FontWeight.bold, // Increased size
                              color: Colors
                                  .red, // Optional: Change color for emphasis
                            ),
                          ),
                          TextSpan(
                            text: "Plasma or Receive!",
                            style: TextStyle(
                              fontSize: 18, // Keep normal size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildOptionCard(
                      title: "Life Giver",
                      color: Colors.green[200]!,
                      imagePath: "assets/images/patient_option.png",
                      onTap: () {
                        Navigator.pushNamed(
                            context, "/auth"); // 🎯 Navigate to Receiver Page
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionCard(
                      title: "Life Receiver",
                      color: Colors.blue[100]!,
                      imagePath: "assets/images/donor_option.png",
                      onTap: () {
                        Navigator.pushNamed(context, "/receiver/option");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🛠 Helper Widget for Option Buttons
  Widget _buildOptionCard({
    required String title,
    required Color color,
    required String imagePath,
    required VoidCallback onTap, // 👈 Added onTap callback
  }) {
    return GestureDetector(
      onTap: onTap, // 🛠 Handle the tap action
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 40), // 🖼 Add your image
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.play_circle_fill, size: 30, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
