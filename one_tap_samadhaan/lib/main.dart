import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garudx_app/l10n/app_localizations.dart';
import 'package:garudx_app/providers/locale_providers.dart';
import 'package:garudx_app/screens/language_selection_screen.dart';
import 'package:garudx_app/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize and set up notifications
  final notificationService = NotificationService();
  await notificationService.initNotifications();
  notificationService.setupMessageListeners();

  // Run the app with the language provider at the top level
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the language provider
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'GarudX',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins', // Make sure you have this font in your assets
      ),
      // Set the locale from the provider
      locale: provider.locale, 
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const LanguageSelectionScreen(),
    );
  }
} 