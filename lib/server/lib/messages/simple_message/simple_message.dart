import 'package:server/component/component.dart';
import 'package:server/model/model.dart';

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

  SimpleMessage.fromMap(Map<String, dynamic> map) : message = map["message"];
  String toJson() {
    return '{message: $message}';
  }
}
