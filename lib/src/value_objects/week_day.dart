import 'package:bits_domain_core/bits_domain_core.dart';

/// WeekDay Value Object
///
/// - Represents a day of the week
///   (1 = Monday to 7 = Sunday, based on ISO 8601 and DateTime package convention)
/// - Immutable
/// - Equality is based on value
/// - Does not depend on DateTime
class WeekDay extends AppEquatable {
  /// Day number (1 = Monday, 7 = Sunday)
  final int _value;

  /// Private constructor to enforce invariants
  const WeekDay._(this._value);

  /// Creates a WeekDay from an integer.
  ///
  /// Returns [BelowRangeWeekDayFailure] below 1 or [AboveRangeWeekDayFailure] above 7.
  static AppResult<WeekDayFailure, WeekDay> fromInt(int value) {
    if (value < 1) {
      return AppResult.left(BelowRangeWeekDayFailure(weekDayValue: value));
    }

    if (value > 7) {
      return AppResult.left(AboveRangeWeekDayFailure(weekDayValue: value));
    }

    return AppResult.right(WeekDay._(value));
  }

  /// Numeric value of the day of the week (1 to 7)
  int get value => _value;

  /// Returns true if this day comes before [other]
  bool isBefore(WeekDay other) => _value < other._value;

  /// Returns true if this day comes after [other]
  bool isAfter(WeekDay other) => _value > other._value;

  /// Returns true if this day is the same as [other]
  bool isSame(WeekDay other) => _value == other._value;

  @override
  List<Object> get equalityProperties => List.unmodifiable([_value]);
}
