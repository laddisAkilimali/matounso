import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const _prefKey = "app_theme_mode";
  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_prefKey) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[index];
    notifyListeners();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _themeMode.index);
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    _saveToPrefs();
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    _saveToPrefs();
    notifyListeners();
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleBetweenLightAndDark() {
    if (_themeMode == ThemeMode.dark) {
      setLightMode();
    } else {
      setDarkMode();
    }
  }
}
