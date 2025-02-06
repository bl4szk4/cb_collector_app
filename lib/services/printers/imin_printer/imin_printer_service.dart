import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_printer/imin_style.dart';

class IminPrinterService {
  final IminPrinter _printer = IminPrinter();

  Future<void> printQRCode({
    required String data,
    int moduleSize = 10,
    int errorLevel = 3,
  }) async {
    try {
      await _printer.initPrinter();
      await _printer.setAlignment(IminPrintAlign.center);

      final IminQrCodeStyle qrCodeStyle = IminQrCodeStyle(
        align: IminPrintAlign.center,
        qrSize: moduleSize,
      );

      await _printer.printQrCode(data, qrCodeStyle: qrCodeStyle);
      await _printer.printAndFeedPaper(100);
    } catch (e) {
      throw Exception('iMinPrinter error: $e');
    }
  }
}
