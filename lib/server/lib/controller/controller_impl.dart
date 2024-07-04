abstract class ControllerImpl {
  const ControllerImpl(this.path);

  final String path;
}

class Post {
  const Post(this.path);
  final String path;
}

class Get {
  const Get(this.path);
  final String path;
}
