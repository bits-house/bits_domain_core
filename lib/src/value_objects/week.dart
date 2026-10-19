import 'package:bits_domain_core/bits_domain_core.dart';

/// Week Value Object
///
/// - Represents a custom week combination consisting of multiple [WeekDay]s.
/// - Immutable.
/// - Equality is based on the normalized (sorted) list of days.
/// - Guarantees that the week contains between 1 and 7 unique days.
class Week extends AppEquatable {
  /// The list of unique, sorted days that make up this week.
  final List<WeekDay> _days;

  /// Private constructor to enforce invariants.
  const Week._(this._days);

  /// Creates a valid [Week] combination from a list of [WeekDay]s.
  ///
  /// Returns [AppResult.right] containing the normalized [Week] if valid.
  /// Returns [AppResult.left] containing a [WeekFailure] if invariants are violated.
  ///
  /// A valid week must:
  /// - Contain at least one day (cannot be empty).
  /// - Consist strictly of unique days (no duplicates).
  static AppResult<WeekFailure, Week> create(List<WeekDay> days) {
    if (days.isEmpty) {
      return const AppResult.left(EmptyWeekFailure());
    }

    final uniqueDays = days.toSet().toList();
    if (uniqueDays.length != days.length) {
      return AppResult.left(
        DuplicateDaysInWeekFailure(duplicateWeekDays: days),
      );
    }

    uniqueDays.sort((a, b) => a.value.compareTo(b.value));

    // List.unmodifiable prevents external modification of the internal state
    // after the Right side is returned, ensuring true immutability.
    return AppResult.right(Week._(List.unmodifiable(uniqueDays)));
  }

  /// The immutable, normalized (sorted and unique) list of days in this week combination.
  List<WeekDay> get days => _days;

  /// Returns true if this week combination includes the specified [day].
  bool contains(WeekDay day) => _days.contains(day);

  @override
  List<Object> get equalityProperties => List.unmodifiable([_days]);
}
