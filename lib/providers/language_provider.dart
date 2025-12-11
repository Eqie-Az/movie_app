import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('id', 'ID'); // Default Bahasa Indonesia

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    if (languageCode == 'id') {
      _currentLocale = const Locale('id', 'ID');
    } else {
      _currentLocale = const Locale('en', 'US');
    }
    notifyListeners(); // Memberitahu semua halaman untuk update
  }
}
