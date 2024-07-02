import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:wormhole/server/server.dart';
import 'package:wormhole/server/session/sessions.dart';

var getIt = GetIt.instance;
void setupGetIt() async {
  var server = await SocketServer.init();
  if (server != null) {
    getIt.registerSingleton<SocketServer>(server);
  }

  getIt.registerSingleton<Sessions>(Sessions());
}
