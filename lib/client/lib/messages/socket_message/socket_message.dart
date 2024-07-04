import 'dart:convert';

import 'package:client/component/component.dart';
import 'package:client/model/model.dart';

@component
class SocketMessage<T extends Model> extends Model {
  SocketMessage(this.path, this.content);
  String path;
  T content;

  @override
  Map<String, dynamic> toMap() {
    return {"path": path, ...content.toMap()};
  }

  toJson() => jsonEncode(toMap());
}
