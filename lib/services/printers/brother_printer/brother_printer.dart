import 'dart:io';
import 'dart:math';
import 'question.dart';
import 'printer_connection.dart';
import 'configuration.dart';
import 'status.dart';
import 'lock.dart';
import 'package:logger/logger.dart';


class BrotherPrinterService {
  final Connection _connection;
  final Logger logger = Logger();
  BrotherPrinterService({required Connection connection})
      : _connection = connection;

  Future<Configuration> getConfiguration() async {
    try {
      await checkAndConnect();
      final question = GetConfig();
      final data = await _sendAndExpect(question);
      return Configuration(data);
    } catch (e) {
      logger.e("Error loading config: $e");
      throw Exception('Error loading configuration: $e');
    }
  }

  Future<Status> getStatus() async {
    try {
      final question = GetStatus();
      final data = await _sendAndExpect(question);
      logger.i(data);
      return Status(data);
    } catch (e) {
      logger.e("Error loading status: $e");
      throw Exception('Error loading status: $e');
    }
  }

  Future<Lock> lock() async {
    try {
      await checkAndConnect();
      final question = LockQuestion();
      final response = await _sendAndExpect(question);
      return Lock(response);
    } catch (e) {
      logger.e('Could not lock: $e');
      throw Exception('Could not lock printer: $e');
    }
  }

  Future<void> release() async {
    try {
      await checkAndConnect();
      final question = Release();
      await _sendAndExpect(question);
    } catch (e) {
      logger.e('could not release printer');
      throw Exception('Could not release printer: $e');
    }
  }

  Future<void> printJpeg(File jpegFile, String mode, String cut, {bool useLock = false}) async {
    try {
      await checkAndConnect();
      final Status status = await getStatus();
      if (status.printState != "IDLE"){
        throw Exception('The printer is busy.');
      }
      logger.i(status.printState);
      String? jobNumber;
      if (useLock) {
        final printerLock = await lock();
        jobNumber = printerLock.jobNumber;
        logger.i('Printer is locked with jobID: $jobNumber');
      }

      final fileSize = jpegFile.lengthSync();
      logger.i('File size: $fileSize bytes');
      final printCommand = Print(
        mode,
        cut,
        fileSize,
        jobNumber: jobNumber,
        imageFile: jpegFile,
      );

      await _sendAndExpect(printCommand);
      logger.i("Sending file");
      await _connection.sendFile(jpegFile);
      logger.i("File sent successfully");

      if (useLock) {
        logger.i('Releasing blockage for task: $jobNumber');
        await release();
      }
    } catch (e) {
      throw Exception('Exception printing file: $e');
    } finally {
      await closeConnection();
    }
  }


  Future<void> waitForReadyState() async {
    while (true) {
      final status = await getStatus();
      if (status.printState == 'READY') break;
      logger.i("Waiting for READY");
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> waitToTurnIdle() async {
    await Future.delayed(const Duration(seconds: 2));

    while (true) {
      final status = await getStatus();
      if (status.printState == 'IDLE') {
        logger.i("Drukarka jest w stanie IDLE");
        break;
      }
      logger.i("Czekanie na przejście drukarki w stan IDLE...");
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  Future<void> checkAndConnect() async {
    if (_connection.isClosed) {
      throw Exception('Połączenie z drukarką jest zamknięte. '
          'Aby ponownie nawiązać komunikację, utwórz nowe połączenie.');
    }
  }

  Future<void> closeConnection() async {
    if (!_connection.isClosed) {
      logger.i("Closing connection with printer");
      _connection.close();
    }
  }

  Future<String> _sendAndExpect(Question question) async {
    try {
      await _connection.sendMessage(question.getData());
      return await _connection.getMessage();
    } catch (e) {
      throw Exception('Error sending command for printer: $e');
    }
  }
}
