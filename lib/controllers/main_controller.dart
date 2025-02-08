import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:pbl_collector/screens/assign_to_user_screen.dart';
import 'package:pbl_collector/screens/print_screen.dart';
import 'package:pbl_collector/services/printers/printer_service.dart';
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

  Service get service => _MainControllerState.instance.service;
  LoggedUser get user => _MainControllerState.instance.user;
}

class _MainControllerState extends State<MainController> {
  static late _MainControllerState instance;

  final Service service = Service();
  final LoggedUser user = LoggedUser();
  final Logger logger = Logger();
  late final PrintingService printingService;

  @override
  void initState() {
    super.initState();
    instance = this;
    _init();
  }

  void _logOut(BuildContext context) {
    logger.i("Logging out...");

    service.logout();

    Future.microtask(() {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }


  Future<void> _init() async {
    logger.i("Initializing Controller...");
    await service.loadLocale();
    await service.init(widget);

    try {
      printingService = await PrintingService.create(
      );
      logger.i("PrintingService initialized successfully.");
    } catch (e) {
      logger.e("Error initializing PrintingService: $e");
    }

    logger.i("Controller initialized");
    setState(() {});
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
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => HomeScreen(mainController: widget),
      '/login': (context) => LoginScreen(mainController: widget),
      '/log-out': (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _logOut(context);
        });
        return const SizedBox.shrink();
      },
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
      '/item/details/edit/assign': (context){
        final itemId = ModalRoute.of(context)!.settings.arguments as int;
        return UserSelectionScreen(mainController: widget, itemId: itemId);
      },
      '/item/details/edit/location': (context) {
        final itemId = ModalRoute.of(context)!.settings.arguments as int;
        return ChangeLocationScreen(mainController: widget, itemId: itemId);
      },
      '/add-location': (context) => AddLocationScreen(mainController: widget),
      '/print-screen': (context) => PrinterScreen(printingService: printingService),
    };
  }
}
