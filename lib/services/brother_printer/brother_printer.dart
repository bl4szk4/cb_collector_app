import 'dart:async';
import 'dart:io';
import 'question.dart';
import 'printer_connection.dart';
import 'configuration.dart';
import 'status.dart';
import 'lock.dart';

class LabelPrinter {
  final Connection _connection;

  LabelPrinter({required Connection connection})
      : _connection = connection;

  Future<Configuration> getConfiguration() async {
    final question = GetConfig();
    final data = await _sendAndExpect(question);
    return Configuration(data);
  }

  Future<Status> getStatus() async {
    final question = GetStatus();
    final data = await _sendAndExpect(question);
    return Status(data);
  }

  Future<Lock> lock() async {
    final question = LockQuestion();
    final response = await _sendAndExpect(question);
    return Lock(response);
  }

  Future<void> release() async {
    final question = Release();
    await _sendAndExpect(question);
  }

  Future<void> printJpeg(File jpegFile, String mode, String cut, {bool useLock = false}) async {
    try {
      String? jobNumber;
      if (useLock) {
        final printerLock = await lock();
        jobNumber = printerLock.jobNumber;
        print('Printer locked with job number: $jobNumber');
      }

      final fileSize = jpegFile.lengthSync();
      final printCommand = Print(
        mode,
        cut,
        fileSize,
        jobNumber: jobNumber,
        imageFile: jpegFile,
      );

      // Wyślij polecenie druku
      if (!_connection.isClosed) {
        await _sendAndExpect(printCommand);
      } else {
        throw Exception('Connection is already closed before sending the print command.');
      }

      print('Sending JPEG file...');
      if (!_connection.isClosed) {
        await _connection.sendFile(jpegFile);
        print('File sent successfully.');
      } else {
        throw Exception('Connection is already closed before sending the JPEG file.');
      }

      await waitToTurnIdle();

      if (useLock) {
        print('Releasing lock for job number: $jobNumber');
        await release();
      }
    } catch (e) {
      throw Exception('Failed to print: $e');
    }
  }

  Future<void> waitForReadyState() async {
    while (true) {
      final status = await getStatus();
      if (status.printState == 'READY') break;
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> waitToTurnIdle() async {
    while (true) {
      final status = await getStatus();
      if (status.printState == 'IDLE') break;
      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<String> _sendAndExpect(Question question) async {
    await _connection.sendMessage(question.getData());
    return await _connection.getMessage();
  }
}


