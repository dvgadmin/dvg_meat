import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = "en";

  String get language => _language;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString("language") ?? "en";
    notifyListeners();
  }

  Future<void> changeLanguage(String lang) async {
    _language = lang;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", lang);

    notifyListeners();
  }

  bool get isEnglish => _language == "en";
}