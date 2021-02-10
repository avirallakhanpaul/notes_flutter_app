import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {

  SharedPreferences _prefs;
  final key = "theme";
  bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _isDarkTheme = false;
    _loadFromPrefs();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _savePref();
    notifyListeners();
  }

  Future<void> _initPref() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  void _loadFromPrefs() async {
    await _initPref();
    _isDarkTheme = _prefs.getBool(key) ?? false; // if it is NULL then set it to false
    notifyListeners();
  }

  void _savePref() async {
    await _initPref();
    _prefs.setBool(key, _isDarkTheme);
  }
}