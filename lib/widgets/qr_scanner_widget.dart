import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatelessWidget {
  final Function(String) onQRCodeScanned;

  const QRScannerWidget({Key? key, required this.onQRCodeScanned}) : super(key: key);

  void _showScannedCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned QR Code'),
          content: Text(code),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Zamknięcie dialogu
                Navigator.pushReplacementNamed(context, '/login', arguments: code); // Przejście do /login z kodem
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              String code = barcode.rawValue!;
              print('Scanned QR Code: $code');
              Navigator.pop(context);
              _showScannedCodeDialog(context, code);
              break;
            }
          }
        },
      ),
    );
  }
}
