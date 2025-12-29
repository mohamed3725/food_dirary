import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode;

  ThemeProvider({ThemeMode initialMode = ThemeMode.system})
      : _mode = initialMode;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void setLight() {
    _mode = ThemeMode.light;
    notifyListeners();
  }

  void setDark() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }

  void setSystem() {
    _mode = ThemeMode.system;
    notifyListeners();
  }

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
