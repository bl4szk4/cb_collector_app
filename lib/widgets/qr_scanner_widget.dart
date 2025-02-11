import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/widgets/navigators/go_back_navigator.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';

class QRScannerWidget extends StatefulWidget {
  final MainController mainController;
  final Function(String) onQRCodeScanned;
  final bool navigateToDetails;
  final String instruction;
  final MobileScannerController scannerController;

  const QRScannerWidget({
    Key? key,
    required this.mainController,
    required this.onQRCodeScanned,
    required this.scannerController,
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
    widget.scannerController.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: widget.scannerController,
            onDetect: (barcodeCapture) {
              if (!_hasScanned) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    String code = barcode.rawValue!;
                    _handleScannedCode(code);
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
              if (mounted) {
                Navigator.pop(context);
              }
              break;
            case 'exit':
              SystemNavigator.pop();
              break;
          }
        },
      ),
    );
  }

  void _handleScannedCode(String code) async {
    if (_hasScanned) return;
    if (!mounted) return;
    setState(() {
      _hasScanned = true;
    });

    if (widget.navigateToDetails) {
      final response =
      await widget.mainController.service.getItemDetailsWithQRCode(code);
      if (!mounted) return;
      if (response.error == ServiceErrors.ok && response.data != null) {
        Navigator.pushReplacementNamed(context, '/items/details',
            arguments: response.data);
      } else {

        _showErrorDialog();
      }
    } else {
      widget.onQRCodeScanned(code);
    }
  }

  void _showErrorDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('error')),
          content: Text(AppLocalizations.of(context)!
              .translate('error_loading_item_details')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  setState(() {
                    _hasScanned = false;
                  });
                }
              },
              child: Text(AppLocalizations.of(context)!.translate('ok')),
            ),
          ],
        );
      },
    );
  }
}
