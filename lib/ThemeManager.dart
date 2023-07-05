import 'package:flutter/material.dart';
import 'package:one/StorageManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow,
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.yellow,
      brightness: Brightness.light,
    ),
  );

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: $value');
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}