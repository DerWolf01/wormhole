import 'package:client/component/component.dart';
import 'package:client/controller/controller_service.dart';
import 'package:client/controller/example/controller_example.dart';
import 'package:client/get_it/get_it.dart';
import 'package:client/messages/simple_message/simple_message.dart';
import 'package:client/messages/socket_message/socket_message.dart' as m;
import 'package:client/messages/socket_request/socket_request.dart';
import 'package:client/socket/client_socket.dart';
import 'client.reflectable.dart';

main(List<String> arguments) async {
  initializeReflectable();
  await setupGetIt();

  getIt<ControllerService>().registerController(ControllerExample());
  getIt<ClientSocket>()
      .send(SocketRequest("/hinda/is-sweet", SimpleMessage("Hello server!")));
}
