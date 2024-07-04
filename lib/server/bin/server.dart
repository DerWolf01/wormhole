import 'dart:io';

import 'package:server/controller/controller_service.dart';
import 'package:server/controller/example/controller_example.dart';
import 'package:server/get_it/get_it.dart';
import 'package:server/socket_server/socket_server.dart';
import 'server.reflectable.dart';

Future<void> main(List<String> arguments) async {
  initializeReflectable();
  await setupGetIt();

  ControllerService().registerController(ControllerExample());
  getIt<SocketServer>().listen();
}
