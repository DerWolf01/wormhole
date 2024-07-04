import 'dart:convert';
import 'dart:io';
import 'package:client/messages/socket_message/socket_message.dart' as message;

import 'package:client/component/component.dart';
import 'package:client/controller/controller.dart';
import 'package:client/controller/controller_service.dart';
import 'package:client/get_it/get_it.dart';
import 'package:client/model/model.dart';

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
    final decodedData = utf8.decode(data);
    print(decodedData);
    final json = jsonDecode(decodedData);
    if (json["path"] == null) {
      print('invalid data $decodedData');
      return;
    }

    var path = json["path"];
    print('path: $path');
    var pingedMethod = getIt<ControllerService>().methodMirrorByFullPath(path);
    if (pingedMethod is AnnotatedMethod<RequestHandler>) {
      var res = pingedMethod.invoke([json]);
      if (res is Model) {
        send(message.SocketMessage(json["path"], res).toJson());
      }
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
