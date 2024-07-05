import 'dart:io';

import 'package:wormhole/server/session/session.dart';
import 'package:wormhole/server/session/sessions.dart';

class SocketServer {
  final String host;
  final int port;
  final ServerSocket _socket;
  static SocketServer? _instance;
  SocketServer._internal(
      {required ServerSocket socket, required this.host, required this.port})
      : _socket = socket;

  static Future<SocketServer?> init(
      {String host = 'localhost', int port = 3000}) async {
    try {
      final server = await ServerSocket.bind("localhost", 3000);

      _instance ??=
          SocketServer._internal(socket: server, host: host, port: port);
    } catch (e) {
      print('Failed to start server: $e');
      return null;
    }
  }

  factory SocketServer() {
    if (_instance == null) throw Exception('SocketServer not initialized');
    return _instance!;
  }

  listen() {
    print("listening on $host$port");
    _socket.listen(
      (socket) {
        var session = UserSession(socket);
        session.start();
        Sessions().addSession(session);
      },
      onError: (error) {
        print('Socket error: $error');
      },
      onDone: () {
        print('Socket closed');
      },
    );
  }
}
