import 'package:client/get_it/get_it.dart';
import 'package:client/socket/client_socket.dart';

main(List<String> arguments) async {
  await setupGetIt();

  getIt<ClientSocket>().send('Hello, server!');
}
