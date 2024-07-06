import 'package:wormhole/common/model/model.dart';
import 'middleware.dart';

class MiddlewareService {
  MiddlewareService._internal();
  static MiddlewareService? _instance;
  factory MiddlewareService() {
    _instance ??= MiddlewareService._internal();

    return _instance!;
  }

  final List<Middleware> middlewares = [];

  void registerMiddleware(Middleware middleware) {
    middlewares.add(middleware);
  }

  void removeMiddleware(Middleware middleware) {
    middlewares.remove(middleware);
  }

  void preHandle(String path, Model data) {
    print("middleware preHandle");
    // Apply each middleware in the order they were added
    for (var middleware in middlewares.where(
      (element) => element.preHandle != null && element.path == path,
    )) {
      middleware.preHandle!(data);
    }
  }

  void postHandle(String path, Model data) {
    // Apply each middleware in the order they were added
    for (var middleware in middlewares.where(
      (element) => element.postHandle != null && element.path == path,
    )) {
      middleware.postHandle!(data);
    }
  }
}
