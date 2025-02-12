import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerRouteArguments {
  final Function(String) onQRCodeScanned;
  final String instruction;

  QRScannerRouteArguments({
    required this.onQRCodeScanned,
    required this.instruction,
  });
}