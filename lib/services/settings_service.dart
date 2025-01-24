import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class SettingsService {
  static Future<Map<String, String>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'printCodes': prefs.getString('printCodes') ?? 'brother',
      'printLabels': prefs.getString('printLabels') ?? 'brother',
    };
  }

  static Future<void> saveSetting(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  static Future<Locale> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('locale');
    return Locale(languageCode ?? 'en');
  }

  static Future<void> saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}
