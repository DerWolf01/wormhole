import 'dart:convert';
import 'dart:io';

import 'package:wormhole/server/server_message_service.dart';
import 'package:wormhole/server/session/sessions.dart';

class UserSession {
  final Socket _socket;
  final String sessionId;

  UserSession(
    this._socket,
  ) : sessionId = DateTime.now().millisecondsSinceEpoch.toString() {
    socketMessageService = ServerMessageService(this);
  }

  late final ServerMessageService socketMessageService;

  void start() {
    print('User session started with session ID: $sessionId');

    _socket.listen(
      (data) {
        final decodedData = utf8.decode(data);
        print('Received data: $decodedData');
        print(decodedData);
        final json = jsonDecode(decodedData);
        print("json: $json");
        socketMessageService.receive(json);
      },
      onError: (error) {
        // Handle socket error
        throw Exception('Socket error: $error');
      },
      onDone: () {
        // Handle socket closed
        print('Socket closed');
        Sessions().removeSession(this);
      },
    );
  }

  Future<void> send(String message) async {
    _socket.write(message);
    return await _socket.done;
  }

  Future<void> close() async {
    return await _socket.close();
  }
}
