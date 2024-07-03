import 'dart:io';

import 'package:server/get_it/get_it.dart';
import 'package:server/socket_server/socket_server.dart';

Future<void> main(List<String> arguments) async {
  await setupGetIt();
  getIt<SocketServer>().listen();
}
