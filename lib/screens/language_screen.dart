import 'package:flutter/material.dart';
import '../widgets/language_button.dart';
import '../services/main_service.dart';

class LanguageScreen extends StatelessWidget {
  final Service service;

  LanguageScreen({required this.service});

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
                service.changeLocale(Locale('pl'));
                Navigator.pop(context);
              },
            ),
            LanguageButton(
              text: 'English',
              flagAsset: 'assets/flags/en.webp',
              onPressed: () {
                service.changeLocale(Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
