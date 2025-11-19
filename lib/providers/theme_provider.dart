import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  static const String _themeModeKey = 'theme_mode';

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Load theme preference from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeModeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
    await _saveThemeMode();
  }

  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveThemeMode();
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeModeKey, _themeMode == ThemeMode.dark);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  // Set dark theme
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set light theme
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }
}
