import 'package:wormhole/component.dart';
import 'package:wormhole/general/messages/register_message/register_message.dart';

@component
class ActiveUserMessage extends RegisterMessage {
  ActiveUserMessage(super.userId);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    print(map);
    return map;
  }
}
