import 'package:wormhole/reflector.dart';

@reflector
class WormholeModel {}

runCheck() {
  for (var value in reflector.annotatedClasses) {
    print(value);
  }
}
