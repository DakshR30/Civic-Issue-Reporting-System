import 'package:flutter/material.dart';
import 'package:garudx_app/providers/locale_providers.dart';
import 'package:garudx_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);

    void navigateToLogin(Locale locale) {
      provider.setLocale(locale); // Set the global locale
      Navigator.push(
        context,
        // The 'selectedLanguage' parameter is no longer needed here
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(150), // Fix for deprecated withOpacity
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/logo.png', height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to One Tap Samadhaan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your one-tap civic issue reporting system.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Updated onPressed callbacks to use Locale objects
                  LanguageButton(language: 'English', onPressed: () => navigateToLogin(const Locale('en'))),
                  const SizedBox(height: 16),
                  LanguageButton(language: 'मराठी', onPressed: () => navigateToLogin(const Locale('mr'))),
                  const SizedBox(height: 16),
                  LanguageButton(language: 'हिन्दी', onPressed: () => navigateToLogin(const Locale('hi'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String language;
  final VoidCallback onPressed;

  const LanguageButton({
    super.key,
    required this.language,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withAlpha(230), // Fix for deprecated withOpacity
        foregroundColor: Colors.indigo,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        language,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

