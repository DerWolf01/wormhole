import 'package:wormhole/common/component/component.dart';
import 'package:wormhole/common/controller/controller.dart';
import 'package:wormhole/common/controller/controller_service.dart';
import 'package:wormhole/common/messages/socket_message/socket_message.dart';
import 'package:wormhole/common/messages/socket_response/socket_response.dart';
import 'package:wormhole/common/model/model.dart';
import 'package:wormhole/wormhole_server/session/session.dart';

class ServerMessageService extends ServerMessageServiceNotifier
    with SocketMessageTypeRecognizer {
  ServerMessageService(this.userSession);
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

class ServerMessageServiceNotifier {
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
