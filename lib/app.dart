import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/login_screen.dart';
import 'package:tiffinmate/screens/onboarding_screen1.dart';
import 'package:tiffinmate/screens/splash_screen.dart';




class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
       initialRoute: '/',
       
      routes: {

        '/login': (context) => const LoginScreen(),
       
      },
    );
    
  }
}