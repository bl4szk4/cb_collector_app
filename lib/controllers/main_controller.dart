import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import '../models/item_details.dart';
import '../models/logged_user.dart';
import '../screens/add_location_screen.dart';
import '../screens/change_item_location_screen.dart';
import '../screens/home_screen.dart';
import '../screens/item_action_screen.dart';
import '../screens/item_details_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/my_items_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/qr_scanner_widget.dart';
import '../services/app_localizations.dart';
import '../services/main_service.dart';

class MainController extends StatefulWidget {
  const MainController({Key? key}) : super(key: key);

  @override
  _MainControllerState createState() => _MainControllerState();

  // Dodanie getterów do właściwości `service` i `user`
  Service get service => _MainControllerState.instance.service;
  LoggedUser get user => _MainControllerState.instance.user;
}

class _MainControllerState extends State<MainController> {
  static late _MainControllerState instance;

  final Service service = Service();
  final LoggedUser user = LoggedUser();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    instance = this;
    _init();
  }

  Future<void> _init() async {
    logger.i("Initializing Controller...");
    await service.loadLocale();
    await service.init(widget);
    logger.i("Controller initialized");
    setState(() {}); // Update UI after initialization
  }

  void _setLocale(Locale locale) async {
    await service.changeLocale(locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CB Scanner',
      theme: ThemeData.dark(),
      locale: service.locale, // Locale set dynamically
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
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => HomeScreen(),
      '/login': (context) => LoginScreen(mainController: widget),
      '/main-screen': (context) => MainScreen(),
      '/qr-scanner': (context) => QRScannerWidget(
        mainController: widget,
        onQRCodeScanned: (String code) {
          Navigator.pushNamed(context, '/login', arguments: code);
        },
        navigateToDetails: false,
        instruction: "Scan your ID",
      ),
      '/qr-scanner/details': (context) => QRScannerWidget(
        mainController: widget,
        onQRCodeScanned: (String code) {},
        navigateToDetails: true,
        instruction: "Scan item",
      ),
      '/settings': (context) => SettingsScreen(setLocale: _setLocale),
      '/my-items': (context) => MyItemsScreen(mainController: widget),
      '/items/details': (context) {
        final item = ModalRoute.of(context)!.settings.arguments as ItemDetails;
        return ItemDetailsScreen(mainController: widget, itemDetails: item);
      },
      '/item/details/edit': (context) {
        final itemId = ModalRoute.of(context)!.settings.arguments as int;
        return ItemActionScreen(mainController: widget, itemId: itemId);
      },
      '/item/details/edit/location': (context) {
        final itemId = ModalRoute.of(context)!.settings.arguments as int;
        return ChangeLocationScreen(mainController: widget, itemId: itemId);
      },
      '/add-location': (context) => AddLocationScreen(mainController: widget),
    };
  }
}
