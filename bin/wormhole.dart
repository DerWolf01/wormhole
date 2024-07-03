library;

import 'package:wormhole/component.dart';
import 'package:wormhole/server/lib/get_it/get_it.dart';
import './wormhole.reflectable.dart';

void main(List<String> arguments) {
  initializeReflectable();
  setupGetIt();

  for (var value in component.annotatedClasses) {
    print(value);
  }
}
