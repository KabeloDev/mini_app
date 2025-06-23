import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeController extends ChangeNotifier {
  static const _storageKey = 'mode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ModeController() {
    _loadMode(); // Load saved theme mode on initialization
  }

  void toggleMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_storageKey, _isDarkMode);
  }

  void _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_storageKey) ?? true; // default to true (dark)
    notifyListeners();
  }
}
