import 'package:wormhole/common/component/component.dart';
import 'package:wormhole/common/middleware/middleware_service.dart';
import 'package:wormhole/common/model/model.dart';

@component
class Middleware<T extends Model> {
  Middleware(this.path, {this.preHandle, this.postHandle});
  final String path;
  Future<void> Function(T accepts)? preHandle;
  Future<void> Function(T accepts)? postHandle;

  register() {
    // register middleware
    MiddlewareService().registerMiddleware(this);
  }
}
