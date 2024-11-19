import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PyxisNewsTheme {
  static ThemeData lightTheme = ThemeData(
    //Light theme primary colors
    primaryColor: const Color(0xffbb86c0),
    scaffoldBackgroundColor: Colors.white,
    
    //AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xffbb86c0),
      centerTitle: true,
      titleTextStyle: GoogleFonts.adventPro(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    //Bottom NavBar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffbb86c0),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
    ),

    //Text Theme
    textTheme: TextTheme(
      headlineSmall: GoogleFonts.adventPro(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ), //Titles text
      bodyLarge: GoogleFonts.lora(
        fontSize: 16,
        color: Colors.black87,
      ), //Body text
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: Colors.black54,
      ), //Author text 
      bodySmall: GoogleFonts.robotoMono(
        fontSize: 12,
        color: Colors.grey[600],
      ),
    ),

    //Icon Theme
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),

  );
}