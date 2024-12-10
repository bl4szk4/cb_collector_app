import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './widgets/qr_scanner_widget.dart';
import './screens/login_screen.dart';
import './screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/qr-scanner': (context) => QRScannerWidget(
          onQRCodeScanned: (code) {
          },
        ),
        '/login': (context) => LoginScreen(),
        '/main_screen': (context) => MainScreen(),
      },
    );
  }
}
