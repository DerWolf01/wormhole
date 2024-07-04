import 'package:server/component/component.dart';
import 'package:server/controller/controller.dart';
import 'package:server/controller/controller_service.dart';
import 'package:server/get_it/get_it.dart';
import 'package:server/messages/socket_message/socket_message.dart';
import 'package:server/messages/socket_response/socket_response.dart';
import 'package:server/model/model.dart';
import 'package:server/session/session.dart';
import 'package:server/socket_server/socket_server.dart';

class SocketMessageService extends SocketMessageServiceNotifier
    with SocketMessageTypeRecognizer {
  SocketMessageService(this.userSession);
  final UserSession userSession;
  ControllerService controllerService = ControllerService();

  Future receive(Map<String, dynamic> message) async {
    assert(message["path"] != null, 'invalid data $message');
    if (message["path"] == null) {
      throw Exception('No path found in SocketMessage! $message');
    }

    if (isRequest(message)) {
      print("is request");
      handleRequest(message);
    } else if (isResponse(message)) {
      handleResponse(message);
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
    print("pingedMethod: $pingedMethod");
    if (pingedMethod is AnnotatedMethod<RequestHandler>) {
      var res = await pingedMethod.invokeUsingMap(message);
      if (res is Model) {
        userSession.send(SocketResponse(message["path"], res).toJson());
      }
    }
  }

  handleResponse(Map<String, dynamic> message) {
    var path = message["path"];
    print('handleResponse-path: $path');
    var pingedMethod =
        controllerService.methodMirrorByFullPath<RequestHandler>(path);
    if (pingedMethod is AnnotatedMethod<RequestHandler>) {
      pingedMethod.invoke([message]);
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
