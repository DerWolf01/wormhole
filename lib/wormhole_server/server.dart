library;

import 'package:wormhole/common/controller/controller_service.dart';
import 'package:wormhole/wormhole_server/controller_example.dart';
import 'package:wormhole/wormhole_server/wormhole_server.dart';

Future<void> main(List<String> arguments) async {
  ControllerService().registerController(ControllerExample());
  WormholeServer().listen();
}
