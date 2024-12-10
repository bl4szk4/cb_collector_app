import 'package:flutter/material.dart';
import '../widgets/language_button.dart';

class LanguageScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  LanguageScreen({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageButton(
              text: 'Polski',
              flagAsset: 'assets/flags/pl.webp',
              onPressed: () {
                onLocaleChange(Locale('pl'));
                Navigator.pop(context);
              },
            ),
            LanguageButton(
              text: 'English',
              flagAsset: 'assets/flags/en.webp',
              onPressed: () {
                onLocaleChange(Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
