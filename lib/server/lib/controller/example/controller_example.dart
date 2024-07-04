import 'package:server/component/component.dart';
import 'package:server/controller/controller.dart';
import 'package:server/messages/simple_message/simple_message.dart';
import 'package:server/session/session.dart';

@Controller("/hinda")
@component
class ControllerExample {
  ControllerExample();

  @RequestHandler("/is-sweet")
  Future<SimpleMessage> clientSaysHello(SimpleMessage message) async {
    print("clientSaysHello --> ${message.message}");
    return SimpleMessage("Server anaswers your hello!");
  }
}
