import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatelessWidget {
  final Function(String) onQRCodeScanned;

  const QRScannerWidget({Key? key, required this.onQRCodeScanned}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              String code = barcode.rawValue!;
              Navigator.pop(context); // Zamknij ekran skanowania
              onQRCodeScanned(code); // Przekaż zeskanowany kod
              break;
            }
          }
        },
      ),
    );
  }
}
