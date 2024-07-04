import 'dart:convert';
import 'package:client/component/component.dart';
import 'package:client/messages/socket_request/socket_request.dart';
import 'package:client/messages/socket_response/socket_response.dart';
import 'package:client/model/model.dart';
export './socket_message.dart';

enum SocketMessageType { request, response }

extension on SocketMessageType {
  Type get type =>
      this == SocketMessageType.request ? SocketRequest : SocketResponse;
}

@component
abstract class SocketMessage<T extends Model> extends Model {
  SocketMessage(this.path, this.content, this.type);
  final SocketMessageType type;
  final String path;
  final T content;

  @override
  Map<String, dynamic> toMap() {
    return {"path": path, "type": type.index, ...content.toMap()};
  }

  String toJson() => jsonEncode(toMap());
}
