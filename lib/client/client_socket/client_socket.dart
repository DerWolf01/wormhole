import 'dart:convert';
import 'dart:io';
import 'package:wormhole/client/client_message_service.dart';
import 'package:wormhole/common/messages/socket_message/socket_message.dart'
    as messages;

export 'client_socket.dart';

class ClientSocket {
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
      _socket = await Socket.connect(host, port);
      print('Connected to $host:$port');
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
