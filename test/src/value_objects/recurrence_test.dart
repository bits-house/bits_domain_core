import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Recurrence value objects', () {
    group('Shared validation', () {
      test('all recurrence types reject a start date after the end date', () {
        final start = DateTime(2026, 2);
        final end = DateTime(2026, 1);

        for (final result in _createAll(start: start, end: end)) {
          final failure = _failureOf(result);
          expect(failure, isA<InvalidRangeRecurrenceFailure>());
          expect(
            (failure as InvalidRangeRecurrenceFailure).startDateTime,
            start,
          );
          expect(failure.endDateTime, end);
        }
      });

      test('range validation takes precedence over invalid intervals', () {
        final result = DailyRecurrence.create(
          startDate: DateTime(2026, 2),
          endDate: DateTime(2026, 1),
          interval: 0,
        );

        expect(_failureOf(result), isA<InvalidRangeRecurrenceFailure>());
      });

      test('all recurrence types reject intervals below one', () {
        for (final interval in [0, -1]) {
          for (final result in _createAll(
            interval: interval,
            end: DateTime(2026, 12, 31),
          )) {
            final failure = _failureOf(result);
            expect(failure, isA<InvalidIntervalRecurrenceFailure>());
            expect(
              (failure as InvalidIntervalRecurrenceFailure).interval,
              interval,
            );
          }
        }
      });

      test('all recurrence types accept an inclusive single-instant range', () {
        final date = DateTime(2026, 6, 15);

        for (final result in _createAll(start: date, end: date)) {
          final recurrence = _successOf(result);
          expect(recurrence.startDateTime, date);
          expect(recurrence.endDateTime, date);
          expect(recurrence.interval, 1);
        }
      });

      test('all recurrence types accept a large positive interval', () {
        const interval = 999999999999999999;
        for (final result in _createAll(
          interval: interval,
          end: DateTime(2026, 12, 31),
        )) {
          expect(_successOf(result).interval, interval);
        }
      });
    });

    group('Recurrence types and attributes', () {
      test('minute and hourly recurrences expose common attributes', () {
        final start = DateTime(2026, 6, 15, 8, 30);
        final end = DateTime(2026, 6, 16);
        final recurrences = [
          _successOf(
            MinuteRecurrence.create(
              startDate: start,
              endDate: end,
              interval: 5,
            ),
          ),
          _successOf(
            HourlyRecurrence.create(
              startDate: start,
              endDate: end,
              interval: 3,
            ),
          ),
        ];

        expect(recurrences[0].interval, 5);
        expect(recurrences[1].interval, 3);
        for (final recurrence in recurrences) {
          expect(recurrence.startDateTime, start);
          expect(recurrence.endDateTime, end);
          expect(recurrence.equalityProperties, hasLength(3));
        }
      });

      test('weekly recurrence retains the supplied immutable week', () {
        final week = _week([5, 1]);
        final recurrence = _successOf(
          WeeklyRecurrence.create(
            startDate: DateTime(2026),
            endDate: DateTime(2026, 12, 31),
            week: week,
          ),
        );

        expect(recurrence.week, week);
        expect(recurrence.week.days.map((day) => day.value), [1, 5]);
        expect(() => recurrence.week.days.clear(), throwsUnsupportedError);
        expect(recurrence.equalityProperties, hasLength(4));
      });

      test('monthly and yearly recurrences retain each configured policy', () {
        for (final policy in OnNonExistentDayOfMonthPolicy.values) {
          final monthly = _successOf(
            MonthlyRecurrence.create(
              startDate: DateTime(2026, 1, 31),
              endDate: DateTime(2030),
              onNonExistentDayOfMonthPolicy: policy,
            ),
          );
          final yearly = _successOf(
            YearlyRecurrence.create(
              startDate: DateTime(2024, 2, 29),
              endDate: DateTime(2030),
              onNonExistentDayOfMonthPolicy: policy,
            ),
          );

          expect(monthly.onNonExistentDayOfMonthPolicy, policy);
          expect(yearly.onNonExistentDayOfMonthPolicy, policy);
          expect(monthly.equalityProperties, hasLength(4));
          expect(yearly.equalityProperties, hasLength(4));
        }
      });

      test('policy and week participate in recurrence equality', () {
        final start = DateTime(2026);
        final end = DateTime(2030);
        final firstWeekly = _successOf(
          WeeklyRecurrence.create(
            startDate: start,
            endDate: end,
            week: _week([1]),
          ),
        );
        final otherWeekly = _successOf(
          WeeklyRecurrence.create(
            startDate: start,
            endDate: end,
            week: _week([2]),
          ),
        );
        final clamp = _successOf(
          MonthlyRecurrence.create(
            startDate: start,
            endDate: end,
            onNonExistentDayOfMonthPolicy:
                OnNonExistentDayOfMonthPolicy.setToLastDayOfMonth,
          ),
        );
        final skip = _successOf(
          MonthlyRecurrence.create(
            startDate: start,
            endDate: end,
            onNonExistentDayOfMonthPolicy:
                OnNonExistentDayOfMonthPolicy.skipOccurrence,
          ),
        );
        final move = _successOf(
          YearlyRecurrence.create(
            startDate: start,
            endDate: end,
            onNonExistentDayOfMonthPolicy:
                OnNonExistentDayOfMonthPolicy.setToFirstDayOfNextMonth,
          ),
        );
        final yearlySkip = _successOf(
          YearlyRecurrence.create(
            startDate: start,
            endDate: end,
            onNonExistentDayOfMonthPolicy:
                OnNonExistentDayOfMonthPolicy.skipOccurrence,
          ),
        );

        expect(firstWeekly, isNot(otherWeekly));
        expect(clamp, isNot(skip));
        expect(move, isNot(yearlySkip));
      });
    });

    group('Value object behavior', () {
      test('equal recurrences have equal hashes', () {
        final start = DateTime(2026, 6, 15);
        final end = DateTime(2026, 12, 31);
        final first = _successOf(
          DailyRecurrence.create(startDate: start, endDate: end),
        );
        final second = _successOf(
          DailyRecurrence.create(startDate: start, endDate: end),
        );

        expect(first, second);
        expect(first.hashCode, second.hashCode);
        expect(first.toString(), contains('DailyRecurrence'));
      });

      test('type and every common attribute contribute to equality', () {
        final start = DateTime(2026, 6, 15);
        final end = DateTime(2026, 12, 31);
        final daily = _successOf(
          DailyRecurrence.create(startDate: start, endDate: end),
        );
        final differentInterval = _successOf(
          DailyRecurrence.create(startDate: start, endDate: end, interval: 2),
        );
        final differentStart = _successOf(
          DailyRecurrence.create(
            startDate: start.add(const Duration(minutes: 1)),
            endDate: end,
          ),
        );
        final differentEnd = _successOf(
          DailyRecurrence.create(
            startDate: start,
            endDate: end.add(const Duration(days: 1)),
          ),
        );
        final minute = _successOf(
          MinuteRecurrence.create(startDate: start, endDate: end),
        );

        expect(daily, isNot(differentInterval));
        expect(daily, isNot(differentStart));
        expect(daily, isNot(differentEnd));
        expect(daily, isNot(minute));
      });

      test(
        'equality property lists are immutable for every recurrence type',
        () {
          final recurrences = _createAll(end: DateTime(2026, 12, 31))
              .map(_successOf)
              .toList();

          for (final recurrence in recurrences) {
            expect(
              () => recurrence.equalityProperties.add(null),
              throwsUnsupportedError,
            );
            expect(() => recurrence.props.clear(), throwsUnsupportedError);
          }
        },
      );
    });
  });
}

List<AppResult<RecurrenceFailure, Recurrence>> _createAll({
  DateTime? start,
  DateTime? end,
  int interval = 1,
}) {
  final actualStart = start ?? DateTime(2026);
  final actualEnd = end ?? DateTime(2026, 12, 31);
  return [
    MinuteRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
    ),
    HourlyRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
    ),
    DailyRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
    ),
    WeeklyRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
      week: _week([1]),
    ),
    MonthlyRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
      onNonExistentDayOfMonthPolicy:
          OnNonExistentDayOfMonthPolicy.setToLastDayOfMonth,
    ),
    YearlyRecurrence.create(
      startDate: actualStart,
      endDate: actualEnd,
      interval: interval,
      onNonExistentDayOfMonthPolicy:
          OnNonExistentDayOfMonthPolicy.setToLastDayOfMonth,
    ),
  ];
}

RecurrenceFailure _failureOf<T>(AppResult<RecurrenceFailure, T> result) {
  return result.fold(
    (failure) => failure,
    (_) => fail('Expected a RecurrenceFailure.'),
  );
}

T _successOf<T>(AppResult<RecurrenceFailure, T> result) {
  return result.fold(
    (failure) => fail('Expected success, got $failure.'),
    (value) => value,
  );
}

Week _week(List<int> dayValues) {
  final result = Week.create(dayValues.map(_weekDay).toList());
  return result.fold(
    (failure) => fail('Expected a Week, got $failure.'),
    (week) => week,
  );
}

WeekDay _weekDay(int value) {
  return WeekDay.fromInt(value).fold(
    (failure) => fail('Expected a WeekDay, got $failure.'),
    (weekDay) => weekDay,
  );
}
