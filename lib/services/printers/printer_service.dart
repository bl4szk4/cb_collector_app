import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../settings_service.dart';
import 'brother_printer/brother_printer.dart';
import 'brother_printer/printer_connection.dart';
import 'imin_printer/imin_printer_service.dart';

class PrintingService {
  final IminPrinterService _iminPrinterService;
  final String _brotherHost;
  final int _brotherPort;
  final Logger logger = Logger();

  PrintingService._(
      this._iminPrinterService,
      this._brotherHost,
      this._brotherPort,
      );

  static Future<PrintingService> create({
    String brotherHost = '192.168.0.179',
    int brotherPort = 9100,
  }) async {
    final iminService = IminPrinterService();
    return PrintingService._(iminService, brotherHost, brotherPort);
  }

  Future<BrotherPrinterService> _getBrotherPrinterService() async {
    final connection = await Connection.connect(_brotherHost, _brotherPort);
    return BrotherPrinterService(connection: connection);
  }

  Future<String> printQRCodeImage(Uint8List imageData) async {
    try {
      final settings = await SettingsService.loadSettings();
      final printerType = settings['printCodes'];
      logger.i('Printer: $printerType');

      final bool applyProcessing = true;

      final file = await _createTempFileFromImage(imageData, applyProcessing: applyProcessing);

      if (printerType == 'internal') {
        await _iminPrinterService.printLabel(file);
        return 'QR code printed.';
      } else if (printerType == 'brother') {
        var brotherService = await _getBrotherPrinterService();
        await brotherService.printJpeg(file, 'normal', 'full');
        brotherService = await _getBrotherPrinterService();
        brotherService.getStatus();
        return 'QR code printed.';
      } else {
        throw Exception('Unknown printer.');
      }
    } catch (e) {
      logger.e('Error printing QR code image: $e');
      return 'Error printing QR code image: $e';
    }
  }

  img.Image convertToBinary(img.Image image, {int threshold = 20}) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        num luminance = img.getLuminance(pixel);
        img.ColorRgb8 color = luminance > threshold ? img.ColorRgb8(255, 255, 255) : img.ColorRgb8(0, 0, 0);
        image.setPixel(x, y, color);
      }
    }
    return image;
  }

  Future<File> _createTempFileFromImage(Uint8List imageData, {bool applyProcessing = true}) async {
    try {
      img.Image? decodedImage = img.decodeImage(imageData);
      if (decodedImage == null) {
        throw Exception('Error in decoding provided image data.');
      }

      if (applyProcessing) {
        final background = img.Image(
          width: decodedImage.width,
          height: decodedImage.height,
        );
        final whiteColor = img.ColorRgb8(255, 255, 255);
        img.fill(background, color: whiteColor);
        img.compositeImage(background, decodedImage);
        decodedImage = background;

        decodedImage = convertToBinary(decodedImage);
      }

      final jpegData = img.encodeJpg(decodedImage, quality: 100);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/qr_code_print.jpeg');
      await tempFile.writeAsBytes(jpegData);

      return tempFile;
    } catch (e) {
      throw Exception('Error in generating file from image data: $e');
    }
  }

  Future<String> printQRCodeFromString(String data) async {
    try {
      final settings = await SettingsService.loadSettings();
      final printerType = settings['printCodes'];
      logger.i('Printer: $printerType');

      if (printerType == 'internal') {
        await _iminPrinterService.printQRCode(data: data);
        return 'QR code printed.';
      } else if (printerType == 'brother') {
        final file = await _createTempFileFromString(data);
        final brotherService = await _getBrotherPrinterService();
        await brotherService.printJpeg(file, 'normal', 'full');
        return 'QR code printed.';
      } else {
        throw Exception('Unknown printer.');
      }
    } catch (e) {
      logger.e('Error printing QR code from string: $e');
      return 'Error printing QR code from string: $e';
    }
  }

  Future<File> _createTempFileFromString(String data) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status != QrValidationStatus.valid) {
        throw Exception('Cant generate code for data: $data');
      }

      final painter = QrPainter.withQr(
        qr: qrValidationResult.qrCode!,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );

      final byteData = await painter.toImageData(2048);
      if (byteData == null) {
        throw Exception('Error in generating QR.');
      }

      final image = img.decodeImage(byteData.buffer.asUint8List());
      if (image == null) {
        throw Exception('Error in decoding QR.');
      }
      final jpegData = img.encodeJpg(image, quality: 100);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/qr_code.jpeg');
      await tempFile.writeAsBytes(jpegData);

      return tempFile;
    } catch (e) {
      throw Exception('Error in generating file with QR: $e');
    }
  }

  Future<File> _convertImageToFile(Uint8List imageData, String filename, {bool applyProcessing = false, int shiftRight = 200}) async {
    try {
      img.Image? decodedImage = img.decodeImage(imageData);
      if (decodedImage == null) {
        throw Exception('Invalid image data: Unable to decode.');
      }

      img.Image shiftedImage = img.Image(
          width: decodedImage.width.toInt() + shiftRight,
          height: decodedImage.height
      );

      final whiteColor = img.ColorRgb8(255, 255, 255);
      img.fill(shiftedImage, color: whiteColor);
      img.compositeImage(shiftedImage, decodedImage, dstX: shiftRight, dstY: 0);

      if (applyProcessing) {
        shiftedImage = convertToBinary(shiftedImage);
      }

      final jpegData = img.encodeJpg(shiftedImage, quality: 95);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename');

      await tempFile.writeAsBytes(jpegData);

      return tempFile;
    } catch (e) {
      throw Exception('Error in generating file from image data: $e');
    }
  }

  Future<String> printLabelImage(Uint8List imageData) async {
    try {
      final settings = await SettingsService.loadSettings();
      final printerType = settings['printLabels'];
      logger.i('Printer: $printerType');

      final file = await _convertImageToFile(imageData, 'label_print.jpeg');

      if (printerType == 'internal') {
        throw Exception('Forbidden printer.');
      } else if (printerType == 'brother') {
        var brotherService = await _getBrotherPrinterService();
        await brotherService.printJpeg(file, 'normal', 'full');
        brotherService = await _getBrotherPrinterService();
        brotherService.getStatus();
        return 'Label printed on Brother.';
      } else {
        throw Exception('Unknown printer label.');
      }
    } catch (e) {
      logger.e('Error printing label image: $e');
      return 'Error printing label image: $e';
    }
  }

}
