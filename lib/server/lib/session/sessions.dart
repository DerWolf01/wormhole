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
}
