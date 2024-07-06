import 'dart:io';

import 'package:wormhole/server/session/session.dart';
import 'package:wormhole/server/session/sessions.dart';

class SocketServer extends SocketServerChangeNotifier {
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

      if (_instance != null) {
        print("server --> listening on localhost:3000");
      } else {
        throw Exception("failed to start server");
      }
    } catch (e) {
      print('Failed to start server: $e');
    }

    return _instance;
  }

  factory SocketServer() {
    if (_instance == null) throw Exception('SocketServer not initialized');
    return _instance!;
  }

  listen() {
    print("listening on $host$port");
    _socket.listen(
      (socket) {
        callPreConnectCallbacks(socket);
        var session = UserSession(socket);
        session.start();
        Sessions().addSession(session);
        callPostConnectCallbacks(session);
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

abstract class SocketServerChangeNotifier {
  List<Function(Socket)> preConnectCallbacks = [];
  List<Function(UserSession)> postConnectCallbacks = [];

  void addPreConnectCallback(Function(Socket) callback) {
    preConnectCallbacks.add(callback);
  }

  void removePreConnectCallback(Function(Socket) callback) {
    preConnectCallbacks.remove(callback);
  }

  void addPostConnectCallback(Function(UserSession) callback) {
    postConnectCallbacks.add(callback);
  }

  void removePostConnectCallback(Function(UserSession) callback) {
    postConnectCallbacks.remove(callback);
  }

  void callPreConnectCallbacks(Socket socket) {
    for (var callback in preConnectCallbacks) {
      callback(socket);
    }
  }

  void callPostConnectCallbacks(UserSession session) {
    for (var callback in postConnectCallbacks) {
      callback(session);
    }
  }
}
