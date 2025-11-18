import 'package:flutter/material.dart';

/// Cores do aplicativo CookEasy
/// Paleta Terracota + Creme
class AppColors {
  // Cores principais
  static const Color terracota = Color(0xFFD05A2A);
  static const Color terracotaDark = Color(0xFFB04A2E);
  static const Color cream = Color(0xFFFFF3E6);
  
  // Gradiente do header
  static const Color gradientStart = Color.fromARGB(255, 211, 137, 105);
  static const Color gradientEnd = Color.fromARGB(255, 204, 122, 87);
  
  // Cores neutras (tema claro)
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Colors.grey;
  static const Color greyLight = Color(0xFFF5F5F5);
  
  // Cores de feedback
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
  
  // Cores do tema escuro
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCard = Color(0xFF3A3A3A);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
}
