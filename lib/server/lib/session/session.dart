import 'dart:convert';
import 'dart:io';

class UserSession {
  final Socket _socket;
  final String _sessionId;

  UserSession(
    this._socket,
  ) : _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  void start() {
    print('User session started with session ID: $_sessionId');

    _socket.listen(
      (data) {
        // Handle incoming data from the client
        print('Received data: ${utf8.decode(data)}');
        send("Hello from server");
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
