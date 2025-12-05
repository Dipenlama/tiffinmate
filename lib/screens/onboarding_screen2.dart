import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/onboard_screen3.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

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
                "assets/images/onboard2.png",
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                "Ghar-jasto Khana? just One Tap.",
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
                     Navigator.push(context, MaterialPageRoute(builder: (_)=>OnboardScreen3()));
                    

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                  // Navigator.pushReplacementNamed(context, "/login");
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
