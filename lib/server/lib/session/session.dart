import 'dart:convert';
import 'dart:io';
import 'package:server/get_it/get_it.dart';
import 'package:server/messages/socket_message/socket_message_service.dart';

class UserSession {
  final Socket _socket;
  final String sessionId;

  UserSession(
    this._socket,
  ) : sessionId = DateTime.now().millisecondsSinceEpoch.toString() {
    socketMessageService = SocketMessageService(this);
  }

  late final SocketMessageService socketMessageService;

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
        print('Socket error: $error');
      },
      onDone: () {
        // Handle socket closed
        print('Socket closed');
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
