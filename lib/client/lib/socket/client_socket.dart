import 'dart:convert';
import 'dart:io';
import 'package:client/get_it/get_it.dart';
import 'package:client/messages/socket_message/socket_message_service.dart';
import 'package:client/messages/socket_message/socket_message.dart' as messages;
export './client_socket.dart';

class ClientSocket {
  Socket? _socket;

  static Future<ClientSocket?> connect() async {
    await setupGetIt();
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

    return await getIt<SocketMessageService>().receive(json);
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

ClientSocket get clientSocket => getIt<ClientSocket>();

send(messages.SocketMessage message) async {
  await clientSocket.send(message);
}
