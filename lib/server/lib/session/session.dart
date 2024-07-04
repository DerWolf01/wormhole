import 'dart:convert';
import 'dart:io';
import 'package:server/component/component.dart';
import 'package:server/controller/controller.dart';
import 'package:server/controller/controller_service.dart';
import 'package:server/get_it/get_it.dart';
import 'package:server/messages/socket_message/socket_message.dart' as message;
import 'package:server/model/model.dart';

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
        send(jsonEncode(message.SocketMessage(
                "/hinda/is-sweet", SimpleMessage("Hello my love"))
            .toMap()));
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

  Future receive(dynamic data) async {
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

  Future<void> send(String message) async {
    _socket.write(message);
    return await _socket.done;
  }

  Future<void> close() async {
    return await _socket.close();
  }
}

@component
class SimpleMessage extends Model {
  const SimpleMessage(this.message);
  final String message;

  @override
  Map<String, dynamic> toMap() {
    return {
      "message": message,
    };
  }

  @override
  String toString() {
    return 'SimpleMessage{message: $message}';
  }
}
