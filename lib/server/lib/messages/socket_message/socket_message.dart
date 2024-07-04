import 'dart:convert';

import 'package:server/component/component.dart';
import 'package:server/model/model.dart';

@component
class SocketMessage extends Model {
  SocketMessage(this.path, this.content);
  String path;
  Model content;

  @override
  Map<String, dynamic> toMap() {
    return {"path": path, ...content.toMap()};
  }

  toJson() => jsonEncode(toMap());
}
