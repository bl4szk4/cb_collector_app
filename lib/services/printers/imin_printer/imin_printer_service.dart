import 'dart:io';
import 'dart:typed_data';

import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_printer/imin_style.dart';
import 'package:image/image.dart' as img;

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

  Future<void> printLabel(File labelFile) async {
    try {
      await _printer.initPrinter();
      await _printer.setAlignment(IminPrintAlign.center);

      final Uint8List bytes = await labelFile.readAsBytes();

      final img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception("Could not decode image");
      }

      final IminPictureStyle pictureStyle = IminPictureStyle(
        alignment: IminPrintAlign.center,
        width: image.width,
        height: image.height,
      );

      await _printer.printSingleBitmap(bytes, pictureStyle: pictureStyle);

      await _printer.printAndFeedPaper(100);
    } catch (e) {
      throw Exception('iMinPrinter printLabel error: $e');
    }
  }
}
