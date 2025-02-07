import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/widgets/navigators/go_back_navigator.dart';
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
  late MobileScannerController _scannerController;
  bool _hasScanned = false;
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showInstructions = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _hasScanned = false; // Reset scanning state when dependencies change
    });
  }

  void _handleScannedCode(BuildContext context, String code) async {
    if (_hasScanned) return; // Prevent multiple scans

    setState(() {
      _hasScanned = true;
    });

    if (widget.navigateToDetails) {
      // Try to fetch item details
      final response = await widget.mainController.service.getItemDetailsWithQRCode(code);
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
  void dispose() {
    _scannerController.dispose(); // Dispose of the scanner controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
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
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pop(context);
            case 'exit':
              SystemNavigator.pop();
              break;
          }
        },
      ),
    );
  }
}
