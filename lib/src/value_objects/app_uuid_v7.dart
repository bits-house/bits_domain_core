import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:uuid/uuid.dart';

/// Represents a UUID version 7.
///
/// Use [AppUuidV7.generate()] to create a new UUID version 7.
/// Use [AppUuidV7.fromString()] to create an instance from an existing UUID version 7 string.
/// Get the UUID value as a string using [AppUuidV7.value].
class AppUuidV7 extends AppEquatable {
  final String _value;

  const AppUuidV7._(this._value);

  /// This method generates a new UUID V7 string every time it is called
  /// and wraps it in an [AppUuidV7] instance returned.
  static AppResult<AppUuidV7Failure, AppUuidV7> generate() {
    return AppResult.right(AppUuidV7._(const Uuid().v7()));
  }

  /// Creates an instance of [AppUuidV7] from an existing UUID version 7 string.
  /// Returns [InvalidFormatAppUuidV7Failure] if the provided string is not a valid UUID version 7.
  static AppResult<AppUuidV7Failure, AppUuidV7> fromString(String value) {
    final regex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );

    if (!regex.hasMatch(value)) {
      return AppResult.left(InvalidFormatAppUuidV7Failure(uuidValue: value));
    }
    return AppResult.right(AppUuidV7._(value));
  }

  /// Gets the UUID value as a string.
  String get value => _value;

  @override
  List<Object?> get equalityProperties => List.unmodifiable([_value]);
}
