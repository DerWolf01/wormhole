import 'package:reflectable/reflectable.dart';
import 'package:server/model/model.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(
          typeCapability,
          libraryCapability,
          metadataCapability,
          declarationsCapability,
          typeAnnotationQuantifyCapability,
          instanceInvokeCapability,
          newInstanceCapability,
        );
}

const Reflector component = Reflector();

ClassMirror classMirror(dynamic element) {
  if (element.runtimeType == Type) {
    return component.reflectType(element) as ClassMirror;
  }
  return component.reflect(element).type;
}

InstanceMirror instanceMirror(dynamic element) {
  return component.reflect(element);
}

List<Object> metadata(dynamic element) {
  return instanceMirror(element).type.metadata;
}

List<MethodMirror> methods(dynamic element) {
  return classMirror(element)
      .declarations
      .values
      .whereType<MethodMirror>()
      .toList();
}

List<AnnotatedMethod<T>> methodsAnnotatedWith<T>(dynamic element) {
  return methods(element)
      .where((element) => element.metadata.whereType<T>().firstOrNull != null)
      .map(
        (e) => AnnotatedMethod<T>(element, e, e.metadata.whereType<T>().first),
      )
      .toList();
}

class AnnotatedMethod<AnotatedWith> {
  final dynamic partOf;
  final MethodMirror method;
  final AnotatedWith annotation;

  AnnotatedMethod(this.partOf, this.method, this.annotation);

  Type methodArgumentType() {
    return method.parameters.first.type.reflectedType;
  }

  dynamic invokeMethodArgumentInstance(
      {required constructorName, required List<dynamic> positionalArguments}) {
    var res = classMirror(methodArgumentType())
        .newInstance("$constructorName", positionalArguments);
    return res;
  }

  Model? invoke(List<dynamic> positionalArguments) {
    return instanceMirror(partOf).invoke(method.simpleName, positionalArguments)
        as Model?;
  }
}
