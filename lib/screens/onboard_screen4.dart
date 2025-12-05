import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/login_screen.dart';

class OnboardScreen4 extends StatelessWidget {
  const OnboardScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Onboard Image
              Image.asset(
                "assets/images/onboard4.png", // replace with your image
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                "Enjoy your meals anytime!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const Spacer(),

              // NEXT button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to LoginScreen
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // SKIP button
              TextButton(
                onPressed: () {
                  print("next button pressed");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
