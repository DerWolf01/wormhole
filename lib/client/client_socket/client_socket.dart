import 'dart:convert';
import 'dart:io';
import 'package:wormhole/client/client_message_service.dart';
import 'package:wormhole/common/messages/socket_message/socket_message.dart'
    as messages;

export 'client_socket.dart';

class ClientSocket extends ClientSocketChangeNotifier {
  Socket? _socket;

  static ClientSocket? _instance;
  ClientSocket._internal();
  static Future<ClientSocket?> connect() async {
    var client = ClientSocket._internal();
    await client._connect('localhost', 3000);
    client.listen();
    return client;
  }

  factory ClientSocket() {
    if (_instance == null) throw Exception('ClientSocket not initialized');
    return _instance!;
  }
  Future<void> _connect(String host, int port) async {
    try {
      callPreConnectCallbacks();
      _socket = await Socket.connect(host, port);
      if (_socket == null) {
        throw Exception('Failed to connect. ');
      }
      callPostConnectCallbacks(this);
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  listen() {
    _socket?.listen((event) {
      receive(event);
    }, onError: (e) {
      print('Error: $e');
    }, onDone: () {
      print('Disconnected');
    });
  }

  Future<void> send(messages.SocketMessage message) async {
    
    if (_socket == null) {
      print('Not connected to any server');
      return;
    }

    try {
      _socket?.write(message.toJson());
      print('Sent: $message');
      return await _socket?.done;
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Future<void> receive(dynamic data) async {
    final decodedData = utf8.decode(data);
    print(decodedData);
    final Map<String, dynamic> json = jsonDecode(decodedData);

    return await ClientMessageService().receive(json);
  }

  Future<void> disconnect() async {
    if (_socket == null) {
      print('Not connected to any server');
      return;
    }

    try {
      await _socket!.close();
      print('Disconnected from server');
    } catch (e) {
      print('Failed to disconnect: $e');
    }
  }
}

ClientSocket get clientSocket => ClientSocket();

send(messages.SocketMessage message) async {
  await clientSocket.send(message);
}

abstract class ClientSocketChangeNotifier {
  List<Function()> preConnectCallbacks = [];
  List<Function(ClientSocket)> postConnectCallbacks = [];

  void addPreConnectCallback(Function() callback) {
    preConnectCallbacks.add(callback);
  }

  void removePreConnectCallback(Function(Socket) callback) {
    preConnectCallbacks.remove(callback);
  }

  void addPostConnectCallback(Function(ClientSocket) callback) {
    postConnectCallbacks.add(callback);
  }

  void removePostConnectCallback(Function(ClientSocket) callback) {
    postConnectCallbacks.remove(callback);
  }

  void callPreConnectCallbacks() {
    for (var callback in preConnectCallbacks) {
      callback();
    }
  }

  void callPostConnectCallbacks(ClientSocket session) {
    for (var callback in postConnectCallbacks) {
      callback(session);
    }
  }
}
