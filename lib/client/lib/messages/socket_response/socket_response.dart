import 'package:client/messages/socket_message/socket_message.dart';
import 'package:client/model/model.dart';
export './socket_response.dart';

class SocketResponse<T extends Model> extends SocketMessage<T> {
  SocketResponse(final String path, final T content)
      : super(path, content, SocketMessageType.response);
}
