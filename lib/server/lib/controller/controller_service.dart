import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';
import 'package:server/component/component.dart';
import 'package:server/controller/controller.dart';
import 'package:characters/characters.dart';

class ControllerService {
  final Map<String, dynamic> _controllerMap = {};

  ControllerService();

  registerController(dynamic controller) {
    var path = Controller.byImplementation(controller).path;
    _controllerMap[path] = controller;
  }

  dynamic getController(String path) {
    return _controllerMap[path];
  }

  Object controllerByFullPath(String fullPath) {
    print(_controllerMap);
    return _controllerMap[_pathByFullPath(fullPath)];
  }

  String _pathByFullPath(String rawFullPath) {
    var path = rawFullPath;
    try {
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
    } catch (e) {
      print(e);
      throw Error.safeToString("No Endpoint found for $rawFullPath");
    }
    return path;
  }

  String methodPath(String fullPath) {
    var controllerPath = _pathByFullPath(fullPath);
    var methodPath = fullPath.substring(controllerPath.length);

    return methodPath;
  }

  dynamic callMethodUsingMap(AnnotatedMethod m, Map map) {
    var argument = m.invokeMethodArgumentInstance(
        constructorName: "fromMap", positionalArguments: [map]);
    return m.partOf.invoke(m.method.simpleName, [argument]);
  }

  AnnotatedMethod? methodMirrorByFullPath<AnotatedWith extends RequestHandler>(
      String fullPath) {
    var controller = controllerByFullPath(fullPath);
    print("controller by full path --> $controller");
    var mPath = methodPath(fullPath);
    print("method path --> $mPath");

    var reflectable = component.reflect(controller);
    print("reflected-controller --> $reflectable");
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
