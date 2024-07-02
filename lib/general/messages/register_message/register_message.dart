import 'package:wormhole/component.dart';
import 'package:wormhole/general/model/model.dart';

@component
class RegisterMessage extends Model {
  RegisterMessage(this.userId);

  int userId;
  @override
  Map<String, dynamic> toMap() => {"userId": userId};
  RegisterMessage.fromMap(Map map) : userId = map["userId"];
}
