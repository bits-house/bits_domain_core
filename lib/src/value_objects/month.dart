import 'package:bits_domain_core/bits_domain_core.dart';

/// Month Value Object
///
/// - Represents a month of the year (1 to 12)
/// - Immutable
/// - Equality is based on value
/// - Does not depend on DateTime
class Month extends AppEquatable {
  /// Month number (1 = January, 12 = December)
  final int _value;

  /// Private constructor to enforce invariants
  const Month._(this._value);

  /// Creates a Month from an integer.
  ///
  /// Returns [BelowRangeMonthFailure] below 1 or [AboveRangeMonthFailure] above 12.
  static AppResult<MonthFailure, Month> fromInt(int value) {
    if (value < 1) {
      return AppResult.left(BelowRangeMonthFailure(monthValue: value));
    }

    if (value > 12) {
      return AppResult.left(AboveRangeMonthFailure(monthValue: value));
    }

    return AppResult.right(Month._(value));
  }

  /// Numeric value of the month (1 to 12)
  int get value => _value;

  /// Returns true if this month comes before [other]
  bool isBefore(Month other) => _value < other._value;

  /// Returns true if this month comes after [other]
  bool isAfter(Month other) => _value > other._value;

  /// Returns true if this month is the same as [other]
  bool isSame(Month other) => _value == other._value;

  /// Indicates whether this is the first month of the year
  bool get isFirstMonth => _value == 1;

  /// Indicates whether this is the last month of the year
  bool get isLastMonth => _value == 12;

  /// Maximum day count for this month.
  int maxDays(int year) {
    return DateTime(year, _value + 1, 0).day;
  }

  @override
  List<Object> get equalityProperties => List.unmodifiable([_value]);
}
