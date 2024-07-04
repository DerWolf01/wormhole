import 'package:client/component/component.dart';

@component
abstract class Model {
  const Model();
  Map<String, dynamic> toMap();
}
