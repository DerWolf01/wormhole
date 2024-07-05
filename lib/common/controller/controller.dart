import 'package:wormhole/common/component/component.dart';
export './controller.dart';

@component
class Controller {
  const Controller(this.path);

  final String path;

  factory Controller.byImplementation(dynamic controller) {
    return metadata(controller).whereType<Controller>().first;
  }
}

@component
abstract class RequestType {
  const RequestType(this.path);
  final String path;
}

@component
class RequestHandler extends RequestType {
  const RequestHandler(super.path);
}

@component
class ResponseHandler extends RequestType {
  const ResponseHandler(super.path);
}
