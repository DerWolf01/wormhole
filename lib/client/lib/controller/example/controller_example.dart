import 'dart:io';

import 'package:client/component/component.dart';
import 'package:client/controller/controller.dart';
import 'package:client/messages/simple_message/simple_message.dart';

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
