import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider de Tema
/// Gerencia o tema claro/escuro do aplicativo
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  /// Carregar tema salvo
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar tema: $e');
    }
  }
  
  /// Alternar entre tema claro e escuro
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await _saveTheme();
    notifyListeners();
  }
  
  /// Definir tema específico
  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Salvar tema
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _themeMode == ThemeMode.dark);
    } catch (e) {
      print('Erro ao salvar tema: $e');
    }
  }
}
