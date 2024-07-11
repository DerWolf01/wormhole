import 'dart:convert';
import 'package:wormhole/common/component/component.dart';
import 'package:wormhole/common/model/model.dart';

/// An abstract class that provides a foundation for models that can be serialized into JSON.
///
/// This class extends [Model] and includes a method for converting model instances into a JSON string.
/// It is designed to be extended by more specific model classes that require JSON serialization capabilities.
/// The [toJson] method leverages Dart's `jsonEncode` function to convert the model's data into a JSON string.
@component
abstract class SerializableModel extends Model {
  /// Constructs a [SerializableModel] instance.
  ///
  /// This constructor is marked as `const` to allow for constant expressions involving [SerializableModel].
  /// It initializes a new instance of [SerializableModel], providing the foundation for JSON serialization.
  const SerializableModel();

  /// Converts the model instance into a JSON string.
  ///
  /// It uses the `jsonEncode` function to serialize the model's data (obtained from the [toMap] method) into a JSON string representation.
  ///
  /// Returns:
  ///   A string representing the serialized JSON data of the model instance.
  String toJson() => jsonEncode(toMap());
}
