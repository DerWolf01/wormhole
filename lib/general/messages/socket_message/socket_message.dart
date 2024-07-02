import 'package:wormhole/component.dart';
import 'package:wormhole/general/model/model.dart';

@component
class SocketMessage<T extends Model> extends Model {
  SocketMessage(this.content);

  T content;
  @override
  Map<String, dynamic> toMap() {
    return {"type": content.runtimeType.toString(), ...content.toMap()};
  }
}
