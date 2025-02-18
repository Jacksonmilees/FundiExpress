import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'UberFont', // Ensure this font exists in pubspec.yaml

    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Headline1 in older versions
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black), // Headline6 in older versions
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87), // BodyText1 in older versions
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54), // BodyText2 in older versions
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
