import 'package:wormhole/reflector.dart';
import 'package:wormhole/wormhole.dart' as wormhole;
import 'package:wormhole/wormhole_model.dart';

import './wormhole.reflectable.dart';

void main(List<String> arguments) {
  print('Hello world: ${wormhole.calculate()}!');
  initializeReflectable();
  reflector.annotatedClasses.forEach(
    (value) {
      print(value);
    },
  );
}

runCheck() {
  for (var value in reflector.annotatedClasses) {
    print(value);
  }
}
