import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = primaryColor;
  bool _useSeedColor = false;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  bool get useSeedColor => _useSeedColor;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  void toggleSeedColor(bool value) {
    _useSeedColor = value;
    notifyListeners();
  }
}
