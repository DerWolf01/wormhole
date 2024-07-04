import 'package:client/component/component.dart';
import 'package:client/controller/controller_service.dart';
import 'package:client/controller/example/controller_example.dart';
import 'package:client/get_it/get_it.dart';
import 'package:client/socket/client_socket.dart';
import 'client.reflectable.dart';

main(List<String> arguments) async {
  initializeReflectable();

  print(component.annotatedClasses);
  await setupGetIt();

  getIt<ControllerService>().registerController(ControllerExample());
  getIt<ClientSocket>().send('Hello, server!');
}
