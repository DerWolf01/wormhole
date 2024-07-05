import 'package:wormhole/common/messages/socket_message/socket_message.dart';
import 'package:wormhole/server/session/session.dart';

class Sessions {
  static Sessions? _instance;
  Sessions._internal();
  factory Sessions() {
    _instance ??= Sessions._internal();
    return _instance!;
  }

  final List<UserSession> _sessions = [];

  void addSession(UserSession session) {
    _sessions.add(session);
  }

  void removeSession(UserSession session) {
    _sessions.remove(session);
  }

  List<UserSession> getSessions() {
    return _sessions;
  }

  UserSession sessionById(String sessionId) {
    return _sessions.firstWhere((session) => session.sessionId == sessionId);
  }
}

UserSession session(String id) => Sessions().sessionById(id);

send(String sessionId, SocketMessage message) async {
  await session(sessionId).send(message.toJson());
}
