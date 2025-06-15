import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isLightMode;

  bool get isLightMode => _isLightMode;

  ThemeProvider({required bool initialMode}) : _isLightMode = initialMode;

  void toggleTheme(bool value) {
    _isLightMode = value;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightMode', _isLightMode);
  }
}
