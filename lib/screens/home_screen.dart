import 'package:flutter/material.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FullWidthButton(
              text: AppLocalizations.of(context)!.translate('login_screen_title'),
              onPressed: () {
                Navigator.pushNamed(context, '/qr-scanner');
              },
            ),
            FullWidthButton(
              text: AppLocalizations.of(context)!.translate('settings'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
