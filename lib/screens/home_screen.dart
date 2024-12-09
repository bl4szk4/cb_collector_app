import 'package:flutter/material.dart';
import '../widgets/full_width_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FullWidthButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushNamed(context, '/qr-scanner');
              },
            ),
            FullWidthButton(
              text: 'About',
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}
