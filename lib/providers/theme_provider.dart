import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode;

  // الحاله الافتراضية للثيم
  ThemeProvider({ThemeMode initialMode = ThemeMode.system})
      : _mode = initialMode;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void setLight() {
    _mode = ThemeMode.light;
    notifyListeners();
  }
  // يطبق ال لايت

  void setDark() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }
  // يطبق الدارك 

  void setSystem() {
    _mode = ThemeMode.system;
    notifyListeners();
  }
  // يحدد الحاله الافتراضية في جهازك 

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  // يبدل الحاله لي قاعده
}
