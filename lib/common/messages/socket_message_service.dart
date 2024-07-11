import 'dart:async';
import 'package:wormhole/common/controller/controller_service.dart';
import 'package:wormhole/common/messages/socket_message/socket_message.dart';
import 'package:wormhole/common/model/serializable_model.dart';

abstract class SocketMessageService extends SocketMessageServiceNotifier
    with SocketMessageTypeRecognizer {
  ControllerService get controllerService => ControllerService();

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

  FutureOr handleRequest(Map<String, dynamic> message);

  FutureOr handleResponse(Map<String, dynamic> message);

  FutureOr send(SerializableModel m);
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
