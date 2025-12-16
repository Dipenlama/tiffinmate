import 'package:flutter/material.dart';
import 'package:tiffinmate/screens/splash_screen.dart';
import 'package:tiffinmate/theme/appbar_theme.dart';
import 'package:tiffinmate/theme/bottom_navigationbar_theme.dart';
import 'package:tiffinmate/theme/textform_field_theme.dart';
import 'package:tiffinmate/theme/theme_data.dart';




class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Apps for College',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme().copyWith(
        appBarTheme: getAppBarTheme(),
        bottomNavigationBarTheme: getBottomNavigationBarTheme(), 
        inputDecorationTheme: getTextFieldTheme()
      ),
      home: const SplashScreen(),
    );
    
  }
}