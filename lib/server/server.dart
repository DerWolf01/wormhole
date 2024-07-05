library;

import 'package:wormhole/common/controller/controller_service.dart';
import 'package:wormhole/common/controller/example/controller_example.dart';
import 'package:wormhole/server/socket_server/socket_server.dart';





Future<void> main(List<String> arguments) async {
  ControllerService().registerController(ControllerExample());
  SocketServer().listen();
}
