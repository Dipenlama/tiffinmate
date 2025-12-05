import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tiffinmate/screens/onboarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to next screen after 2 seconds
    Timer(const Duration(seconds: 3), () {
     Navigator.push(context, MaterialPageRoute(builder: (_)=>OnboardScreen1()));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              "assets/images/Rectangle.png",
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
