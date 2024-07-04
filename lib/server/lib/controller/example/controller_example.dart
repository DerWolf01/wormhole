import 'package:server/component/component.dart';
import 'package:server/controller/controller.dart';
import 'package:server/session/session.dart';

@Controller("/hinda")
@component
class ControllerExample {
  ControllerExample();

  @Get("/is-sweet")
  Future<SimpleMessage> clientSaysHello(SimpleMessage message) async {
    print("helloServer --> Got data: ${message.message}");
    return SimpleMessage("Hello from the server!");
  }
}
