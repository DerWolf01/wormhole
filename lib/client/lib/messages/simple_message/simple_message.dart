import 'package:client/component/component.dart';
import 'package:client/model/model.dart';

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

  SimpleMessage.fromMap(Map map) : message = map["message"];
  String toJson() {
    return '{message: $message}';
  }
}
