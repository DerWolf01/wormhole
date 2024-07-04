import 'package:server/messages/socket_message/socket_message.dart';
import 'package:server/model/model.dart';

class SocketResponse<T extends Model?> extends SocketMessage<T> {
  SocketResponse(final String path, final T content)
      : super(path, content, SocketMessageType.response);
}
