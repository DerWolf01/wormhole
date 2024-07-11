import 'package:wormhole/common/component/component.dart';
export './model.dart';

@component
abstract class Model {
  const Model();

  Map<String, dynamic> toMap();
}
