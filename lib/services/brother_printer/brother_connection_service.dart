import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart'; // Do sprawdzania typu MIME pliku

class Connection {
  late Socket _socket;
  late Stream<Uint8List> _broadcastStream;
  final Duration _timeoutStandard = Duration(seconds: 5);
  final Duration _timeoutFlush = Duration(seconds: 1);
  final Duration _timeoutLong = Duration(seconds: 30);

  Connection._();

  static Future<Connection> connect(String host, [int port = 9100]) async {
    final connection = Connection._();
    await connection._initialize(host, port);
    return connection;
  }

  Future<void> _initialize(String host, int port) async {
    try {
      _socket = await Socket.connect(host, port).timeout(_timeoutStandard);
      _broadcastStream = _socket.asBroadcastStream();
      await flush();
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  Future<void> flush() async {
    try {
      await _broadcastStream.timeout(_timeoutFlush).drain();
    } catch (e) {
      // Ignorujemy błędy podczas flush
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      if (_socket != null) {
        _socket.add(utf8.encode(message));
        await _socket.flush();
      } else {
        throw Exception('Socket is null or closed.');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }


  Future<void> sendFile(File file) async {
    try {
      final stream = file.openRead();
      await stream.pipe(_socket);
    } catch (e) {
      throw Exception('Failed to send file: $e');
    }
  }

  Future<String> getMessage({bool longTimeout = false, int bufferSize = 4096}) async {
    try {
      final timeout = longTimeout ? _timeoutLong : _timeoutStandard;
      final completer = Completer<String>();
      final buffer = StringBuffer();

      final subscription = _broadcastStream.listen(
            (data) {
          if (!completer.isCompleted) {
            buffer.write(utf8.decode(data));
            completer.complete(buffer.toString());
          }
        },
        onError: (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },
        cancelOnError: true,
      );

      // Anuluj subskrypcję po zakończeniu
      completer.future.then((_) => subscription.cancel());
      completer.future.catchError((_) => subscription.cancel());

      return await completer.future.timeout(timeout);
    } on TimeoutException {
      throw Exception('Receiving message timed out.');
    } catch (e) {
      throw Exception('Failed to receive message: $e');
    }
  }


  void close() {
    _socket.close();
  }
}

class LabelPrinter {
  final Connection _connection;

  LabelPrinter(this._connection);

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
      final connection = await Connection.connect('192.168.0.179');
      final printer = LabelPrinter(connection);

      String? jobNumber;
      if (useLock) {
        final lock = await printer.lock();
        jobNumber = lock.jobNumber;
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

      await printer._sendAndExpect(printCommand);

      print('Sending JPEG file...');
      await connection.sendFile(jpegFile);
      print('File sent successfully.');

      await printer.waitToTurnIdle();

      if (useLock) {
        print('Releasing lock for job number: $jobNumber');
        await printer.release();
      }

      connection.close(); // Zamknięcie tylko po zakończeniu całego procesu
    } catch (e) {
      throw Exception('Failed to print: $e');
    }
  }

  Future<void> waitForReadyState(LabelPrinter printer) async {
    while (true) {
      final status = await printer.getStatus();
      if (status.printState == 'READY') break;
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> waitToTurnIdle() async {
    while (true) {
      final status = await getStatus();
      if (status.printState == 'IDLE') break;
      await Future.delayed(Duration(seconds: 2));
      print("chuj");
    }
  }

  Future<String> _sendAndExpect(Question question) async {
    await _connection.sendMessage(question.getData());
    return await _connection.getMessage();
  }
}

class Question {
  final String data;

  Question(this.data);

  String getData() {
    return '<?xml version="1.0" encoding="UTF-8"?>\n$data';
  }
}

class GetConfig extends Question {
  GetConfig() : super('<read>\n<path>/config.xml</path>\n</read>');
}

class GetStatus extends Question {
  GetStatus() : super('<read>\n<path>/status.xml</path>\n</read>');
}

class LockQuestion extends Question {
  LockQuestion()
      : super('<lock>\n<op>set</op>\n<page_count>-1</page_count>\n<job_timeout>99</job_timeout>\n</lock>');
}


class Release extends Question {
  Release() : super('<lock>\n<op>cancel</op>\n</lock>');
}

class Print extends Question {
  Print(String mode, String cut, int dataSize, {String? jobNumber, required File imageFile})
      : super('<print>\n'
      '<mode>${mode}</mode>\n'
      '<speed>${_getModeValues(mode)['speed']}</speed>\n'
      '<lpi>${_getModeValues(mode)['lpi']}</lpi>\n'
      '<width>${_getImageWidth(imageFile)}</width>\n'
      '<height>${_getImageHeight(imageFile)}</height>\n'
      '<dataformat>jpeg</dataformat>\n'
      '<autofit>1</autofit>\n'
      '<datasize>$dataSize</datasize>\n'
      '<cutmode>$cut</cutmode>\n'
      '${jobNumber != null ? "<job_token>$jobNumber</job_token>\n" : ""}'
      '</print>');

  static Map<String, Object> _getModeValues(String mode) {
    final modes = {
      'vivid': {'name': 'vivid', 'speed': 0, 'lpi': 317},
      'normal': {'name': 'color', 'speed': 1, 'lpi': 264},
    };
    return modes[mode] ?? modes['normal']!;
  }

  static int _getImageWidth(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    return image?.width ?? 0;
  }

  static int _getImageHeight(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    return image?.height ?? 0;
  }
}

class Configuration {
  final String model;
  final double? tapeLengthInitial;
  final double? tapeWidth;

  Configuration(String xml)
      : model = _getStringXmlValue('model_name', xml) ?? 'Unknown',
        tapeLengthInitial = _getDoubleXmlValue('media_length_initial', xml),
        tapeWidth = _getDoubleXmlValue('width_inches', xml);

  static String? _getStringXmlValue(String name, String xml) {
    final regex = RegExp('<$name>(.+?)</$name>');
    final match = regex.firstMatch(xml);
    return match?.group(1);
  }

  static double? _getDoubleXmlValue(String name, String xml) {
    final value = _getStringXmlValue(name, xml);
    return value != null ? double.tryParse(value) : null;
  }
}

class Status {
  final String printState;
  final String printJobStage;
  final String printJobError;
  final double? tapeLengthRemaining;

  Status(String xml)
      : printState = _getStringXmlValue('print_state', xml) ?? 'Unknown',
        printJobStage = _getStringXmlValue('print_job_stage', xml) ?? 'Unknown',
        printJobError = _getStringXmlValue('print_job_error', xml) ?? 'Unknown',
        tapeLengthRemaining = _getDoubleXmlValue('remain', xml);

  static String? _getStringXmlValue(String name, String xml) {
    final regex = RegExp('<$name>(.+?)</$name>');
    final match = regex.firstMatch(xml);
    return match?.group(1);
  }

  static double? _getDoubleXmlValue(String name, String xml) {
    final value = _getStringXmlValue(name, xml);
    return value != null ? double.tryParse(value) : null;
  }
}

class Lock {
  final String jobNumber;
  final String comment;

  Lock(String xml)
      : jobNumber = _getStringXmlValue('job_token', xml) ?? '',
        comment = _getStringXmlValue('comment', xml) ?? '';

  static String? _getStringXmlValue(String name, String xml) {
    final regex = RegExp('<$name>(.+?)</$name>');
    final match = regex.firstMatch(xml);
    return match?.group(1);
  }
}
