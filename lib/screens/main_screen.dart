import 'package:flutter/material.dart';
import '../widgets/full_width_button.dart';
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
                Navigator.pushNamed(context, '/scan-item');
              },
            ),
            FullWidthButton(
              text:  'Add',
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            FullWidthButton(
              text: 'STH',
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
            ),
            FullWidthButton(
              text:  AppLocalizations.of(context)!.translate('log_out'),
              onPressed: () {
                Navigator.pushNamed(context, '');
              },
            ),
          ],
        ),
      ),
    );
  }
}
