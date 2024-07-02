import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector() : super(typeCapability, libraryCapability);
}

const Reflector reflector = Reflector();
