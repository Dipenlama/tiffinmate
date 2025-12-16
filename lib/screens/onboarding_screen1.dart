import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/login_screen.dart';
import 'package:tiffinmate/screens/onboarding_screen2.dart';

class OnboardScreen1 extends StatelessWidget {
  const OnboardScreen1({super.key});

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
                "assets/images/onboard1.png",
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                "Easy Meals for Busy Days.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Spacer pushes content upward
              const Spacer(),

              // NEXT button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  
                    // Navigator.pushNamed(context, "/onboard2");
                     Navigator.push(context, MaterialPageRoute(builder: (_)=>OnboardScreen2()));
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
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // SKIP button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>LoginScreen()));
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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
