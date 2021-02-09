import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with ChangeNotifier {

//   bool isDarkThemeEnabled;

//   Future<void> toggleAndSetTheme() async {

//     isDarkThemeEnabled = !isDarkThemeEnabled;

//     print("Toggled DarkTheme: $isDarkThemeEnabled");

//     final sharedPref = await SharedPreferences.getInstance();
//     await sharedPref.setBool("darkTheme", isDarkThemeEnabled);
//     notifyListeners();
//   }

//   void initTheme() async {

//     final sharedPref = await SharedPreferences.getInstance();
//     final storedTheme = sharedPref.getBool("darkTheme");

//     print("In Device Storage: $storedTheme");

//     if(storedTheme == null) {
//       isDarkThemeEnabled = false;
//     } else {
//       isDarkThemeEnabled = storedTheme;
//     }

//     print("isDarkTheme: $isDarkThemeEnabled");

//     // if(isDarkThemeEnabled) {
//     //   return Future<bool>.value(true);
//     // } else {
//     //   return Future<bool>.value(false);
//     // }
//   }
// }

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