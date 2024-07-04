import 'package:server/get_it/get_it.dart';
import 'package:server/messages/socket_message/socket_message.dart';
import 'package:server/session/session.dart';

class Sessions {
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

UserSession session(String id) => getIt<Sessions>().sessionById(id);

send(String sessionId, SocketMessage message) async {
  await session(sessionId).send(message.toJson());
}
