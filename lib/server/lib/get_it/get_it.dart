import 'package:get_it/get_it.dart';
import 'package:server/controller/controller_service.dart';
import 'package:server/session/sessions.dart';
import 'package:server/socket_server/socket_server.dart';

var getIt = GetIt.instance;
Future<void> setupGetIt() async {
  var server = await SocketServer.init();
  if (server != null) {
    getIt.registerSingleton<SocketServer>(server);
    getIt.registerSingleton<ControllerService>(ControllerService());
    getIt.registerSingleton<Sessions>(Sessions());
  }
}
