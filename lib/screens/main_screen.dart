import 'package:flutter/material.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FullWidthButton(
              text:  AppLocalizations.of(context)!.translate('my_items'),
              onPressed: () {
                Navigator.pushNamed(context, '/my-items');
              },
            ),
            FullWidthButton(
              text:  AppLocalizations.of(context)!.translate('scan_item'),
              onPressed: () {
                Navigator.pushNamed(context, '/qr-scanner/details');
              },
            ),
            FullWidthButton(
              text:  AppLocalizations.of(context)!.translate('add'),
              onPressed: () {
                Navigator.pushNamed(context, '/add-location');
              },
            ),
            FullWidthButton(
              text:  AppLocalizations.of(context)!.translate('log_out'),
              onPressed: () {
                Navigator.pushNamed(context, '/log-out');
              },
            ),
          ],
        ),
      ),
    );
  }
}
