import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './services/app_localizations.dart';
import './screens/home_screen.dart';
import './widgets/qr_scanner_widget.dart';
import './screens/login_screen.dart';
import './screens/main_screen.dart';
import './screens/language_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CB Scanner',
      theme: ThemeData.dark(),
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/qr-scanner': (context) => QRScannerWidget(
          onQRCodeScanned: (code) {},
        ),
        '/login': (context) => LoginScreen(),
        '/main_screen': (context) => MainScreen(),
        '/language': (context) => LanguageScreen(onLocaleChange: _changeLanguage),

      },
    );
  }
}
