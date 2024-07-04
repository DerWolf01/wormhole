import 'package:characters/characters.dart';
import 'package:client/component/component.dart';
import 'package:client/controller/controller.dart';
import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';
export './controller_service.dart';

class ControllerService {
  final Map<String, dynamic> _controllerMap = {};
  static ControllerService? _instance;
  ControllerService._internal();
  factory ControllerService() {
    _instance ??= ControllerService._internal();
    return _instance!;
  }

  registerController(dynamic controller) {
    var path = Controller.byImplementation(controller).path;
    _controllerMap[path] = controller;
  }

  dynamic getController(String path) {
    return _controllerMap[path];
  }

  Object controllerByFullPath(String fullPath) {
    return _controllerMap[_pathByFullPath(fullPath)];
  }

  String _pathByFullPath(String rawFullPath) {
    var path = rawFullPath;
    if (path.characters.first == "/") {
      path = "/";
      for (int i = 1; i < rawFullPath.characters.length; i++) {
        var char = rawFullPath.characters.elementAt(i);
        if (char == "/") {
          break;
        }
        path += char;
      }
    }
    return path;
  }

  String methodPath(String fullPath) {
    var controllerPath = _pathByFullPath(fullPath);
    var methodPath = fullPath.substring(controllerPath.length);

    return methodPath;
  }

  dynamic callMethodFromMap(AnnotatedMethod m, Map map) {
    var argument = m.invokeMethodArgumentInstance(
        constructorName: "fromMap", positionalArguments: [map]);
    return m.partOf.invoke(m.method.simpleName, [argument]);
  }

  AnnotatedMethod? methodMirrorByFullPath<AnotatedWith extends RequestType>(
      String fullPath) {
    var controller = controllerByFullPath(fullPath);
    var mPath = methodPath(fullPath);
    var reflectable = component.reflect(controller);
    AnnotatedMethod? res = methodsAnnotatedWith<AnotatedWith>(controller)
        .where(
          (e) => e.annotation.path == mPath,
        )
        .firstOrNull;

    print("Anotated method found --> ${res?.method.simpleName} --> $res  ");

    return res;
  }
}

extension AnnotationExtension on MethodMirror {
  isAnottatedWith<T>() {
    return this.metadata.forEach(
          (element) => element,
        );
    // return this.metadata.where((element) => element.reflectee == T);
  }
}
