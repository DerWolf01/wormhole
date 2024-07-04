import 'dart:convert';
import 'package:server/component/component.dart';
import 'package:server/messages/socket_request/socket_request.dart';
import 'package:server/messages/socket_response/socket_response.dart';
import 'package:server/model/model.dart';
export './socket_message.dart';

enum SocketMessageType { request, response }

extension on SocketMessageType {
  Type get type =>
      this == SocketMessageType.request ? SocketRequest : SocketResponse;
}

@component
abstract class SocketMessage<T extends Model?> extends Model {
  SocketMessage(this.path, this.content, this.type);
  final SocketMessageType type;
  final String path;
  final T content;

  @override
  Map<String, dynamic> toMap() {
    if (content == null) return {"path": path, "type": type.index};
    return {"path": path, "type": type.index, ...content!.toMap()};
  }

  String toJson() => jsonEncode(toMap());
}
