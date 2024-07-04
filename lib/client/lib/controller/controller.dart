import 'package:client/component/component.dart';

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
class Post extends RequestHandler {
  const Post(super.path);
}

@component
class Get extends RequestHandler {
  const Get(super.path);
}
