import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pbl_collector/services/main_service.dart';
import 'package:logger/logger.dart';

import '../models/logged_user.dart';
import '../screens/home_screen.dart';
import '../widgets/qr_scanner_widget.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/print_screen.dart';
import '../services/app_localizations.dart';
import '../services/settings_service.dart';

class MainController extends StatelessWidget {
  final Service service = Service();
  final LoggedUser user = LoggedUser();
  final Logger logger = Logger();

  MainController({super.key}) {
    _init();
  }

  Future<void> _init() async {
    logger.i("Initializing Controller...");
    await service.loadLocale();
    await service.init(this);
    logger.i("Controller initialized");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CB Scanner',
      theme: ThemeData.dark(),
      locale: service.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(mainController: this),
        '/main-screen': (context) => MainScreen(),
        '/qr-scanner': (context) => QRScannerWidget(
          onQRCodeScanned: (String code) {
            Navigator.pushNamed(context, '/login', arguments: code);
          },
        ),
        '/settings': (context) => SettingsScreen()
      },
    );
  }
}
