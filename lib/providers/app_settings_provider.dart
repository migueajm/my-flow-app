import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguageMode { system, es, en }

class AppSettingsProvider extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _languageKey = 'language_mode';
  static const _guestKey = 'guest_session';

  ThemeMode themeMode = ThemeMode.system;
  AppLanguageMode languageMode = AppLanguageMode.system;
  bool isGuest = false;
  bool isReady = false;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = ThemeMode.values.byName(
      prefs.getString(_themeKey) ?? ThemeMode.system.name,
    );
    languageMode = AppLanguageMode.values.byName(
      prefs.getString(_languageKey) ?? AppLanguageMode.system.name,
    );
    isGuest = prefs.getBool(_guestKey) ?? false;
    isReady = true;
    notifyListeners();
  }

  Locale? get locale {
    if (languageMode == AppLanguageMode.system) return null;
    return Locale(languageMode.name);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, value.name);
    notifyListeners();
  }

  Future<void> setLanguageMode(AppLanguageMode value) async {
    languageMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, value.name);
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    isGuest = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
    notifyListeners();
  }
}
