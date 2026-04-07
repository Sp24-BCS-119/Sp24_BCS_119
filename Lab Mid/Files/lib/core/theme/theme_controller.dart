import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _soundKey = 'sound_profile';

  ThemeMode _themeMode = ThemeMode.system;
  String _soundProfile = 'Default';

  ThemeMode get themeMode => _themeMode;
  String get soundProfile => _soundProfile;

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final storedTheme = preferences.getString(_themeKey);
    final storedSound = preferences.getString(_soundKey);

    _themeMode = switch (storedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _soundProfile = storedSound ?? 'Default';
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await preferences.setString(_themeKey, value);
  }

  Future<void> setSoundProfile(String sound) async {
    _soundProfile = sound;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_soundKey, sound);
  }
}
