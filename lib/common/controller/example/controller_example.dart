import 'package:wormhole/common/component/component.dart';
import 'package:wormhole/common/controller/controller.dart';
import 'package:wormhole/common/messages/simple_message/simple_message.dart';

@Controller("/hinda")
@component
class ControllerExample {
  ControllerExample();

  @ResponseHandler("/is-sweet")
  Future<SimpleMessage> serverAnswersHello(SimpleMessage message) async {
    print("serverAnswersHello --> ${message.message}");
    return SimpleMessage("Client Says Hello!");
  }
}
