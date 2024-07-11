import 'package:wormhole/common/messages/socket_message/socket_message.dart';
import 'package:wormhole/wormhole_server/session/client_session.dart';

class ClientSessions {
  static ClientSessions? _instance;

  ClientSessions._internal();

  factory ClientSessions() {
    _instance ??= ClientSessions._internal();
    return _instance!;
  }

  final List<ClientSession> _clientSessions = [];

  void addSession(ClientSession session) {
    _clientSessions.add(session);
  }

  void removeSession(ClientSession session) {
    _clientSessions
        .removeWhere((element) => element.sessionId == session.sessionId);
  }

  List<ClientSession> getClientSessions() {
    return _clientSessions;
  }

  ClientSession sessionById(String sessionId) {
    return _clientSessions
        .firstWhere((session) => session.sessionId == sessionId);
  }
}

ClientSession session(String id) => ClientSessions().sessionById(id);

send(String sessionId, SocketMessage message) async {
  await session(sessionId).send(message.toJson());
}
