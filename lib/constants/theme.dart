import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        selectedIconTheme: IconThemeData(size:35),
        unselectedIconTheme: IconThemeData(size: 33),
        showSelectedLabels: false,
        showUnselectedLabels: false,

      )
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
  );
}