import 'dart:convert';
import 'dart:io';

class ClientSocket {
  Socket? _socket;

  static Future<ClientSocket?> connect() async {
    var client = ClientSocket();
    await client._connect('localhost', 3000);
    client.listen();
    return client;
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

  Future<void> send(String message) async {
    if (_socket == null) {
      print('Not connected to any server');
      return;
    }

    try {
      _socket?.write(message);
      print('Sent: $message');
      return await _socket?.done;
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Future<void> receive(dynamic data) async {
    if (data == null) {
      print('Not connected to any server');
      return;
    }

    try {
      final decoedeData = utf8.decode(data);
      print('Received: $decoedeData');
    } catch (e) {
      print('Failed to receive data: $e');
    }
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
