import 'package:client/component/component.dart';
import 'package:client/controller/controller.dart';
import 'package:client/controller/controller_service.dart';
import 'package:client/get_it/get_it.dart';
import 'package:client/messages/socket_message/socket_message.dart';
import 'package:client/messages/socket_response/socket_response.dart';
import 'package:client/model/model.dart';
import 'package:client/socket/client_socket.dart';

class SocketMessageService extends SocketMessageServiceNotifier
    with SocketMessageTypeRecognizer {
  ControllerService controllerService = ControllerService();
  ClientSocket get clientSocket => getIt<ClientSocket>();
  Future receive(Map<String, dynamic> message) async {
    if (message["path"] == null) {
      print('invalid data $message');
      return;
    }

    if (isRequest(message)) {
      await handleRequest(message);
    } else if (isResponse(message)) {
      await handleResponse(message);
    } else {
      print("not a valid SocketMessage!");
      return;
    }
  }

  handleRequest(Map<String, dynamic> message) async {
    var path = message["path"];
    print('handleRequest-path: $path');
    var pingedMethod =
        controllerService.methodMirrorByFullPath<RequestHandler>(path);
    if (pingedMethod is AnnotatedMethod<RequestHandler>) {
      var res = await pingedMethod.invokeUsingMap(message);
      if (res is Model) {
        clientSocket.send(SocketResponse(message["path"], res));
      }
    }
  }

  handleResponse(Map<String, dynamic> message) async {
    var path = message["path"];
    print('handleResponse-path: $path');
    AnnotatedMethod? pingedMethod =
        controllerService.methodMirrorByFullPath<ResponseHandler>(path);
    if (pingedMethod is AnnotatedMethod<ResponseHandler>) {
      await pingedMethod.invokeUsingMap(message);
    } else {
      throw Exception(
          "${pingedMethod?.partOf.runtimeType}.${(pingedMethod as AnnotatedMethod).method.simpleName}(${pingedMethod.methodArgumentType()}) is not a ResponseHandler!");
    }
    notifyResponseListeners(message);
  }
}

mixin class SocketMessageTypeRecognizer {
  isRequest(Map<String, dynamic> message) {
    return message["type"] == SocketMessageType.request.index;
  }

  isResponse(Map<String, dynamic> message) {
    return message["type"] == SocketMessageType.response.index;
  }
}

class SocketMessageServiceNotifier {
  final List<Function(dynamic value)> _responseListeners = [];

  void addResponseListener(Function(dynamic) listener) {
    _responseListeners.add(listener);
  }

  void removeResponseListener(Function(dynamic) listener) {
    _responseListeners.remove(listener);
  }

  void notifyResponseListeners(dynamic data) {
    for (var listener in _responseListeners) {
      listener(data);
    }
  }
}
