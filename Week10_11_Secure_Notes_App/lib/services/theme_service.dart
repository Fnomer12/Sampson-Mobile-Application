import 'package:flutter/material.dart';
import 'secure_storage_service.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadTheme() async {
    _isDarkMode = await SecureStorageService.loadThemeMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await SecureStorageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
}