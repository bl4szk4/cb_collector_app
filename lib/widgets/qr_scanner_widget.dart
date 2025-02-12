import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'navigators/go_back_navigator.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onQRCodeScanned;
  final String instruction;
  final bool scanOnce;
  final bool autoTorch;

  const QRScannerWidget({
    Key? key,
    required this.onQRCodeScanned,
    this.instruction = '',
    this.scanOnce = true,
    this.autoTorch = true,
  }) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  late final MobileScannerController _localScannerController;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _localScannerController = MobileScannerController();
    _localScannerController.start();
    _localScannerController.toggleTorch();

  }

  @override
  void dispose() {
    _localScannerController.toggleTorch();
    _localScannerController.stop();
    _localScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _localScannerController,
            onDetect: (barcodeCapture) {
              if (!_hasScanned || !widget.scanOnce) {
                for (final barcode in barcodeCapture.barcodes) {
                  if (barcode.rawValue != null) {
                    _handleScannedCode(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          if (widget.instruction.isNotEmpty)
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

  void _handleScannedCode(String code) {
    if (widget.scanOnce) {
      setState(() {
        _hasScanned = true;
      });
    }
    Navigator.pop(context);
    widget.onQRCodeScanned(code);
  }
}
