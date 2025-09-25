import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('hi'), // Hindi
    const Locale('mr'), // Marathi
  ];
}
