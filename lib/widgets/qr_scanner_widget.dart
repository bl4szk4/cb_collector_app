import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import '../models/service_response.dart';
import '../models/item_details.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';

class QRScannerWidget extends StatelessWidget {
  final MainController mainController;
  final Function(String) onQRCodeScanned;
  final bool navigateToDetails;

  const QRScannerWidget({
    Key? key,
    required this.mainController,
    required this.onQRCodeScanned,
    this.navigateToDetails = false,
  }) : super(key: key);

  void _handleScannedCode(BuildContext context, String code) async {
    if (navigateToDetails) {
      // Try to fetch item details
      final response = await mainController.service.getItemDetails(code);
      if (response.error == ServiceErrors.ok && response.data != null) {
        Navigator.pushReplacementNamed(
          context,
          '/items/details',
          arguments: response.data,
        );
      } else {
        Navigator.pop(context); // Return to the previous route on error
        _showErrorDialog(context);
      }
    } else {
      onQRCodeScanned(code);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('error')),
          content: Text(AppLocalizations.of(context)!.translate('error_loading_item_details')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.translate('ok')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('qr_scanner')),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              String code = barcode.rawValue!;
              _handleScannedCode(context, code);
              break;
            }
          }
        },
      ),
    );
  }
}
