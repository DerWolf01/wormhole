import 'package:wormhole/common/messages/socket_message/socket_message.dart';
import 'package:wormhole/common/model/model.dart';
export './socket_request.dart';

class SocketRequest<T extends Model> extends SocketMessage<T> {
  SocketRequest(final String path, final T content)
      : super(path, content, SocketMessageType.request);
}
