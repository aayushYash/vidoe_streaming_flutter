import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Theme
  static final ThemeData darkTheme = ThemeData( 
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1DB954),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: TextTheme(
      headline1: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyText1: GoogleFonts.inter(fontSize: 16, color: const Color(0xFFE0E0E0)),
      button: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF292929),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF00796B),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: TextTheme(
      headline1: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      bodyText1: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF424242)),
      button: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE0E0E0),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
