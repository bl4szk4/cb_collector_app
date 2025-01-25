import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import '../models/service_response.dart';
import '../models/item_details.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';

class QRScannerWidget extends StatefulWidget {
  final MainController mainController;
  final Function(String) onQRCodeScanned;
  final bool navigateToDetails;
  final String instruction;

  const QRScannerWidget({
    Key? key,
    required this.mainController,
    required this.onQRCodeScanned,
    this.navigateToDetails = false,
    this.instruction = '',
  }) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  bool _hasScanned = false;
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showInstructions = false;
      });
    });
  }

  void _handleScannedCode(BuildContext context, String code) async {
    if (_hasScanned) return; // Prevent multiple scans

    setState(() {
      _hasScanned = true;
    });

    if (widget.navigateToDetails) {
      // Try to fetch item details
      final response = await widget.mainController.service.getItemDetails(code);
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
      widget.onQRCodeScanned(code);
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
                setState(() {
                  _hasScanned = false; // Reset scanning state after error
                });
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
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcodeCapture) {
              if (!_hasScanned) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    String code = barcode.rawValue!;
                    _handleScannedCode(context, code);
                    break;
                  }
                }
              }
            },
          ),
          if (_showInstructions)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  widget.instruction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
