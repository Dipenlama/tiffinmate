import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'OpenSans Italic',
        
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'OpenSans Bold',

            ),
            backgroundColor: Color.fromARGB(0, 164, 219, 164),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),

          )
        )
      );
}
  