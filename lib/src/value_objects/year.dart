import '../common/app_equatable.dart';
import '../common/app_result.dart';
import '../failures/year_failure.dart';

/// Year Value Object
///
/// - Represents a calendar year
/// - Immutable
/// - Equality based on value
class Year extends AppEquatable {
  final int _value;

  const Year._(this._value);

  /// Creates a valid Year
  static AppResult<YearFailure, Year> fromInt(int value) {
    if (value < 1) {
      return AppResult.left(InvalidYearFailure(yearValue: value));
    }

    return AppResult.right(Year._(value));
  }

  int get value => _value;

  /// Returns true if this year is before [other]
  bool isBefore(Year other) => _value < other._value;

  /// Returns true if this year is after [other]
  bool isAfter(Year other) => _value > other._value;

  @override
  List<Object?> get equalityProperties => List.unmodifiable([_value]);
}
