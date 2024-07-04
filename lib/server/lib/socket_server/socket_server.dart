import 'dart:io';
import 'package:server/get_it/get_it.dart';
import 'package:server/session/session.dart';
import 'package:server/session/sessions.dart';
import 'package:server/messages/socket_message/socket_message.dart' as m;

class SocketServer {
  final String host;
  final int port;
  final ServerSocket _socket;

  SocketServer._internal(
      {required ServerSocket socket, required this.host, required this.port})
      : _socket = socket;

  static Future<SocketServer?> init(
      {String host = 'localhost', int port = 3000}) async {
    try {
      final server = await ServerSocket.bind("localhost", 3000);

      return SocketServer._internal(socket: server, host: host, port: port);
    } catch (e) {
      print('Failed to start server: $e');
      return null;
    }
  }

  listen() {
    print("listening on $host$port");
    _socket.listen(
      (socket) {
        var session = UserSession(socket);
        session.start();
        getIt<Sessions>().addSession(session);
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
