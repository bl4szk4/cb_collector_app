import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/widgets/navigators/go_back_navigator.dart';
import '../services/app_localizations.dart';
import '../models/service_response.dart';
import '../models/item_details.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/small_button.dart';
import '../widgets/navigators/bottom_navigator.dart';
import '../widgets/qr_scanner_widget.dart';

class ChangeLocationScreen extends StatefulWidget {
  final MainController mainController;
  final int itemId;

  const ChangeLocationScreen({
    super.key,
    required this.mainController,
    required this.itemId,
  });

  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  Future<void> _scanLocation(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerWidget(
          mainController: widget.mainController,
          onQRCodeScanned: (String code) async {
            final response = await widget.mainController.service.changeLocation(widget.itemId, code);
            if (response.error == ServiceErrors.ok && response.data != null) {
              Navigator.pushReplacementNamed(
                context,
                '/items/details',
                arguments: response.data,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.translate('error_changing_location')),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          instruction: 'Scan new location',
        ),
      ),
    );

  }

  void _navigateToAddLocation(BuildContext context) {
    Navigator.pushNamed(context, '/add-location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('scan_location'),
              onPressed: () => _scanLocation(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pushNamed(context, '/item/details/edit', arguments: widget.itemId);
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
