import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/home_screen.dart';
import 'package:tiffinmate/screens/login_screen.dart';
import 'package:tiffinmate/splash_screen.dart';




class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
    
  }
}