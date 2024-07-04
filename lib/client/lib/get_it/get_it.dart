import 'dart:io';
import 'package:client/controller/controller_service.dart';
import 'package:client/socket/client_socket.dart';
import 'package:get_it/get_it.dart';

var getIt = GetIt.instance;
Future<void> setupGetIt() async {
  var client = await ClientSocket.connect();
  if (client != null) {
    getIt.registerSingleton<ClientSocket>(client);
    getIt.registerSingleton<ControllerService>(ControllerService());
  }
}
