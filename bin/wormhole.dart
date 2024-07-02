library;

import 'package:wormhole/component.dart';
import 'package:wormhole/server/get_it/get_it.dart';
import 'package:wormhole/wormhole.dart' as wormhole;
import './wormhole.reflectable.dart';
export 'package:wormhole/wormhole.dart';

void main(List<String> arguments) {
  print('Hello world: ${wormhole.calculate()}!');
  initializeReflectable();
  setupGetIt();

  for (var value in component.annotatedClasses) {
    print(value);
  }
}
