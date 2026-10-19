import 'package:bits_domain_core/bits_domain_core.dart';

/// Defines the strategy used when a recurring date falls on a day that does not
/// exist in a given month (e.g., February 29th in a non-leap year, or the 31st of April).
enum OnNonExistentDayOfMonthPolicy {
  /// Adjusts the date to the last available day of the target month.
  /// Example: Scheduling for the 31st in April results in April 30th.
  setToLastDayOfMonth,

  /// Skips the recurrence entirely for the affected month.
  /// Example: Scheduling for the 31st skips February and triggers next on March 31st.
  skipOccurrence,

  /// Pushes the occurrence forward to the first day of the following month.
  /// Example: Scheduling for the 31st in April results in May 1st.
  setToFirstDayOfNextMonth,
}

/// Represents a recurrence pattern for date and time, such as hourly, daily, weekly, monthly, or yearly.
sealed class Recurrence extends AppEquatable {
  /// The start DateTime of the recurrence, next occurrence will be based on this date.
  final DateTime _startDateTime;

  /// The end DateTime of the recurrence.
  final DateTime _endDateTime;

  /// The interval of the recurrence. E.g., every 1 minute, every 1 day, every 1 week, every 5 month, etc.
  final int _interval;

  /// Private constructor to enforce invariants
  const Recurrence._({
    required this._startDateTime,
    required this._endDateTime,
    required this._interval,
  });

  DateTime get startDateTime => _startDateTime;

  DateTime get endDateTime => _endDateTime;

  int get interval => _interval;

  static AppResult<RecurrenceFailure, T>
  _createValidated<T extends Recurrence>({
    required DateTime startDateTime,
    required DateTime endDateTime,
    required int interval,
    required T Function() create,
  }) {
    if (startDateTime.isAfter(endDateTime)) {
      return AppResult.left(
        InvalidRangeRecurrenceFailure(
          startDateTime: startDateTime,
          endDateTime: endDateTime,
        ),
      );
    }

    if (interval < 1) {
      return AppResult.left(
        InvalidIntervalRecurrenceFailure(interval: interval),
      );
    }

    return AppResult.right(create());
  }

  @override
  List<Object?> get equalityProperties =>
      List.unmodifiable([_startDateTime, _endDateTime, _interval]);
}

// ========== Minute Recurrence ==========
class MinuteRecurrence extends Recurrence {
  const MinuteRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
  }) : super._();

  /// Creates a [MinuteRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, MinuteRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => MinuteRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
      ),
    );
  }
}

// ========== Hourly Recurrence ==========

class HourlyRecurrence extends Recurrence {
  const HourlyRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
  }) : super._();

  /// Creates a [HourlyRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, HourlyRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => HourlyRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
      ),
    );
  }
}

// ========== Daily Recurrence ==========

class DailyRecurrence extends Recurrence {
  const DailyRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
  }) : super._();

  /// Creates a [DailyRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, DailyRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => DailyRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
      ),
    );
  }
}

// ========== Weekly Recurrence ==========

class WeeklyRecurrence extends Recurrence {
  /// A [Week] value object that contains the days of the week on which the recurrence occurs.
  /// E.g., every Monday and Wednesday, or every Friday, etc.
  final Week _week;

  const WeeklyRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
    required this._week,
  }) : super._();

  Week get week => _week;

  /// Creates a [WeeklyRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, WeeklyRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    required Week week,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => WeeklyRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
        week: week,
      ),
    );
  }

  @override
  List<Object?> get equalityProperties =>
      List.unmodifiable([...super.equalityProperties, _week]);
}

// ========== Monthly Recurrence ==========

class MonthlyRecurrence extends Recurrence {
  final OnNonExistentDayOfMonthPolicy _onNonExistentDayOfMonthPolicy;

  const MonthlyRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
    required this._onNonExistentDayOfMonthPolicy,
  }) : super._();

  OnNonExistentDayOfMonthPolicy get onNonExistentDayOfMonthPolicy =>
      _onNonExistentDayOfMonthPolicy;

  /// Creates a [MonthlyRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, MonthlyRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    required OnNonExistentDayOfMonthPolicy onNonExistentDayOfMonthPolicy,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => MonthlyRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
        onNonExistentDayOfMonthPolicy: onNonExistentDayOfMonthPolicy,
      ),
    );
  }

  @override
  List<Object?> get equalityProperties => List.unmodifiable([
    ...super.equalityProperties,
    onNonExistentDayOfMonthPolicy,
  ]);
}

// ========== Yearly Recurrence ==========

class YearlyRecurrence extends Recurrence {
  final OnNonExistentDayOfMonthPolicy _onNonExistentDayOfMonthPolicy;

  const YearlyRecurrence._({
    required super.startDateTime,
    required super.endDateTime,
    required super.interval,
    required this._onNonExistentDayOfMonthPolicy,
  }) : super._();

  OnNonExistentDayOfMonthPolicy get onNonExistentDayOfMonthPolicy =>
      _onNonExistentDayOfMonthPolicy;

  /// Creates a [YearlyRecurrence] or returns the failure for invalid values.
  static AppResult<RecurrenceFailure, YearlyRecurrence> create({
    required DateTime startDate,
    required DateTime endDate,
    required OnNonExistentDayOfMonthPolicy onNonExistentDayOfMonthPolicy,
    int interval = 1,
  }) {
    return Recurrence._createValidated(
      startDateTime: startDate,
      endDateTime: endDate,
      interval: interval,
      create: () => YearlyRecurrence._(
        startDateTime: startDate,
        endDateTime: endDate,
        interval: interval,
        onNonExistentDayOfMonthPolicy: onNonExistentDayOfMonthPolicy,
      ),
    );
  }

  @override
  List<Object?> get equalityProperties => List.unmodifiable([
    ...super.equalityProperties,
    onNonExistentDayOfMonthPolicy,
  ]);
}
