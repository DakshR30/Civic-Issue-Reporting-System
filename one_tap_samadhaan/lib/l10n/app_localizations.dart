import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late final Map<String, String> _localizedStrings;

  Future<bool> load() {
    // English Strings
    Map<String, String> english = {
      'welcome_to_garudx': 'Welcome to GarudX',
      'tagline': 'Your one-tap civic issue reporting system.',
      'select_language': 'Please select your language',
      'login_welcome_back': 'Welcome Back!',
      'login_enter_mobile': 'Enter your mobile number to continue',
      'login_get_otp': 'Get OTP',
      'login_mobile_number': 'Mobile Number',
      'home_report_new_issue': 'Report New Issue',
      'home_submitted': 'Submitted',
      'home_in_progress': 'In Progress',
      'home_resolved': 'Resolved',
      'home_view_nearby': 'View Nearby Problems',
      'home_recent_reports': 'Recent Reports',
    };

    // Hindi Strings
    Map<String, String> hindi = {
      'welcome_to_garudx': 'गरुड़X में आपका स्वागत है',
      'tagline': 'आपकी एक-टैप नागरिक समस्या रिपोर्टिंग प्रणाली।',
      'select_language': 'कृपया अपनी भाषा चुनें',
      'login_welcome_back': 'पुनः स्वागत है!',
      'login_enter_mobile': 'जारी रखने के लिए अपना मोबाइल नंबर दर्ज करें',
      'login_get_otp': 'ओटीपी प्राप्त करें',
      'login_mobile_number': 'मोबाइल नंबर',
      'home_report_new_issue': 'नई समस्या की रिपोर्ट करें',
      'home_submitted': 'प्रस्तुत',
      'home_in_progress': 'कार्यवाही में',
      'home_resolved': 'हल हो गई',
      'home_view_nearby': 'आस-पास की समस्याएं देखें',
      'home_recent_reports': 'हाल की रिपोर्ट',
    };

    // Marathi Strings
    Map<String, String> marathi = {
      'welcome_to_garudx': 'गरुडX मध्ये आपले स्वागत आहे',
      'tagline': 'तुमची एक-टॅप नागरी समस्या तक्रार प्रणाली.',
      'select_language': 'कृपया आपली भाषा निवडा',
      'login_welcome_back': 'पुन्हा स्वागत आहे!',
      'login_enter_mobile': 'सुरू ठेवण्यासाठी तुमचा मोबाईल नंबर टाका',
      'login_get_otp': 'OTP मिळवा',
      'login_mobile_number': 'मोबाईल नंबर',
      'home_report_new_issue': 'नवीन तक्रार नोंदवा',
      'home_submitted': 'सादर केले',
      'home_in_progress': 'प्रगतीपथावर',
      'home_resolved': 'निराकरण झाले',
      'home_view_nearby': 'जवळच्या समस्या पहा',
      'home_recent_reports': 'नवीनतम तक्रारी',
    };

    switch (locale.languageCode) {
      case 'hi':
        _localizedStrings = hindi;
        break;
      case 'mr':
        _localizedStrings = marathi;
        break;
      default:
        _localizedStrings = english;
    }

    return Future.value(true);
  }

  // Helper method to get a translation
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
