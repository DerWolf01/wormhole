import 'package:server/messages/socket_message/socket_message.dart';
import 'package:server/model/model.dart';

class SocketRequest<T extends Model> extends SocketMessage<T> {
  SocketRequest(final String path, final T content)
      : super(path, content, SocketMessageType.request);
}
