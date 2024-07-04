import 'package:server/component/component.dart';

@component
class Controller {
  const Controller(this.path);

  final String path;

  factory Controller.byImplementation(dynamic controller) {
    return metadata(controller).whereType<Controller>().first;
  }
}

@component
class RequestHandler {
  const RequestHandler(this.path);
  final String path;
}

@component
class ResponseHandler {
  const ResponseHandler(this.path);
  final String path;
}
