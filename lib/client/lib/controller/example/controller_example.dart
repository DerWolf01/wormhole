import 'dart:io';

import 'package:client/component/component.dart';
import 'package:client/controller/controller.dart';
import 'package:client/messages/simple_message/simple_message.dart';

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
