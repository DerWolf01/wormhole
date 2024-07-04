import 'package:client/messages/socket_message/socket_message.dart';
import 'package:client/model/model.dart';
export './socket_request.dart';

class SocketRequest<T extends Model> extends SocketMessage<T> {
  SocketRequest(final String path, final T content)
      : super(path, content, SocketMessageType.request);
}
