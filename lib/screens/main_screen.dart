import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/models/sub_models/qr_scanner_route_arguments.dart';
import 'package:pbl_collector/widgets/navigators/bottom_navigator.dart';
import '../controllers/main_controller.dart';
import '../services/qr_code_scan_processing.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';

class MainScreen extends StatelessWidget {
  final MainController mainController;
  const MainScreen({Key? key, required this.mainController}) : super(key: key);
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
              text: AppLocalizations.of(context)!.translate('scan'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/qr-scanner',
                  arguments: QRScannerRouteArguments(
                    instruction: AppLocalizations.of(context)!.translate('scan_id'),
                    onQRCodeScanned: (String code) async {
                      final qrProcessingService = QRCodeProcessingService(
                        service: mainController.service,
                        context: context
                      );
                      await qrProcessingService.processQRCode(code);
                    },
                  ),
                );
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
      bottomNavigationBar: CustomBottomNavigation(
        onTabSelected: (tab) {
          switch (tab) {
            case 'settings':
              Navigator.pushNamed(context, '/settings');
              break;
            case 'main':
              break;
            case 'exit':
              SystemNavigator.pop();
              break;
          }
        },
      ),
    );
  }
}
