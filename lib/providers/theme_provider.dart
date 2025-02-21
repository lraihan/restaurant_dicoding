import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = primaryColor;
  bool _useSeedColor = false;
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = TimeOfDay(hour: 11, minute: 0);

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  bool get useSeedColor => _useSeedColor;
  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay get notificationTime => _notificationTime;

  ThemeProvider() {
    _loadSettings();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveSettings();
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    _saveSettings();
    notifyListeners();
  }

  void toggleSeedColor(bool value) {
    _useSeedColor = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setNotificationTime(TimeOfDay time) {
    _notificationTime = time;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _seedColor = Color(prefs.getInt('seedColor') ?? primaryColor.value);
    _useSeedColor = prefs.getBool('useSeedColor') ?? false;
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    final hour = prefs.getInt('notificationHour') ?? 11;
    final minute = prefs.getInt('notificationMinute') ?? 0;
    _notificationTime = TimeOfDay(hour: hour, minute: minute);
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeMode.index);
    prefs.setInt('seedColor', _seedColor.value);
    prefs.setBool('useSeedColor', _useSeedColor);
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setInt('notificationHour', _notificationTime.hour);
    prefs.setInt('notificationMinute', _notificationTime.minute);
  }
}
