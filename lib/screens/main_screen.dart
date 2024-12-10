import 'package:flutter/material.dart';
import '../widgets/full_width_button.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FullWidthButton(
              text: 'My items',
              onPressed: () {
                Navigator.pushNamed(context, '');
              },
            ),
            FullWidthButton(
              text: 'Scan Item',
              onPressed: () {
                Navigator.pushNamed(context, '');
              },
            ),
            FullWidthButton(
              text: 'Log out',
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
