import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pbl_collector/screens/assign_to_user_screen.dart';
import 'package:pbl_collector/screens/print_screen.dart';
import 'package:pbl_collector/services/printers/printer_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/logged_user.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../models/sub_models/qr_scanner_route_arguments.dart';
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
    _initCamera();
    _init();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
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
      '/qr-scanner': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as QRScannerRouteArguments?;
        if (args == null) {
          return const Scaffold(
            body: Center(child: Text("No arguments")),
          );
        }
        return QRScannerWidget(
          onQRCodeScanned: args.onQRCodeScanned,
          instruction: args.instruction,
        );
      },
      '/settings': (context) => SettingsScreen(setLocale: _setLocale),
      '/my-items': (context) => MyItemsScreen(mainController: widget),
      '/items/details': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as ItemDetailsRouteArguments?;
        if (args == null) {
          return const Scaffold(
            body: Center(child: Text("No arguments")),
          );
        }
        return ItemDetailsScreen(
          mainController: widget,
          itemId: args.itemId,
          routeOrigin: args.routeOrigin,
          itemDetails: args.itemDetails
        );
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
      '/print-screen': (context) {
        final itemId = ModalRoute
            .of(context)!
            .settings
            .arguments as int;
        return PrinterScreen(printingService: printingService,
            itemId: itemId,
            mainController: widget);
      }
    };
  }
}
