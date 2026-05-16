import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF0E9F6E);

  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Colors.grey.shade50,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Montserrat',
  );
}
