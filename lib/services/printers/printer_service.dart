import 'dart:io';
import './../settings_service.dart';
import 'brother_printer/brother_printer.dart';
import 'brother_printer/printer_connection.dart';
import 'imin_printer/imin_printer_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;

//TODO: translations
class PrintingService {
  final IminPrinterService _iminPrinterService;
  BrotherPrinterService? _brotherPrinterService;
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
    if (_brotherPrinterService == null) {
      final connection = await Connection.connect(_brotherHost, _brotherPort);
      _brotherPrinterService = BrotherPrinterService(connection: connection);
    }
    return _brotherPrinterService!;
  }

  Future<String> printCode(String data) async {
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
      logger.e('Error printing code: $e');
      return 'Error printing code: $e';
    }
  }

  Future<String> printLabel(File labelFile) async {
    try {
      final settings = await SettingsService.loadSettings();
      final printerType = settings['printLabels'];

      if (printerType == 'internal') {
        throw Exception('Forbidden printer.');
      } else if (printerType == 'brother') {
        final brotherService = await _getBrotherPrinterService();
        await brotherService.printJpeg(labelFile, 'normal', 'full');
        return 'Label printed on Brother.';
      } else {
        throw Exception('Unknown printer label.');
      }
    } catch (e) {
      logger.e('Error printing label: $e');
      return 'Error printing label: $e';
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
      final jpegData = img.encodeJpg(image);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/qr_code.jpeg');
      await tempFile.writeAsBytes(jpegData);

      return tempFile;
    } catch (e) {
      throw Exception('Error in generating file with QR: $e');
    }
  }

}
