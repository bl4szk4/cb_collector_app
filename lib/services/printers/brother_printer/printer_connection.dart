import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Connection {
  late Socket _socket;
  late Stream<Uint8List> _broadcastStream;
  final Duration _timeoutStandard = Duration(seconds: 5);
  final Duration _timeoutFlush = Duration(seconds: 1);
  final Duration _timeoutLong = Duration(seconds: 30);
  bool _isClosed = false;

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
      _isClosed = false;
      await flush();
    } catch (e) {
      _isClosed = true;
      throw Exception('Failed to connect: $e');
    }
  }

  Future<void> flush() async {
    try {
      await _broadcastStream.timeout(_timeoutFlush).drain();
    } catch (e) {
      // Ignoruj błędy podczas czyszczenia
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      if (!_isClosed && _socket != null) {
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
      if (!_isClosed && _socket != null) {
        final stream = file.openRead();
        await stream.pipe(_socket);
      } else {
        throw Exception('Socket is null or closed.');
      }
    } catch (e) {
      throw Exception('Failed to send file: $e');
    }
  }

  Future<String> getMessage({bool longTimeout = false, int bufferSize = 4096}) async {
    try {
      if (_isClosed) {
        throw Exception('Socket is closed. Cannot receive message.');
      }

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
    if (!_isClosed) {
      _socket.close();
      _isClosed = true;
    }
  }

  bool get isClosed => _isClosed;
}
