import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Week Value Object', () {
    group('Construction & validation', () {
      test('returns EmptyWeekFailure for an empty list', () {
        final result = Week.create([]);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<EmptyWeekFailure>()),
          (_) => fail('Expected an empty week failure.'),
        );
      });

      test('returns DuplicateDaysInWeekFailure for duplicate days', () {
        final monday = _weekDay(1);
        final result = Week.create([monday, monday]);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<DuplicateDaysInWeekFailure>());
            expect(
              (failure as DuplicateDaysInWeekFailure)
                  .duplicateWeekDays
                  .map((day) => day.value),
              [1, 1],
            );
          },
          (_) => fail('Expected a duplicate days failure.'),
        );
      });

      test('returns a normalized Week for unique days', () {
        final result = Week.create([_weekDay(5), _weekDay(1)]);

        expect(result.isRight, isTrue);
        result.fold(
          (failure) => fail('Expected a Week, got $failure.'),
          (week) => expect(week.days.map((day) => day.value), [1, 5]),
        );
      });
    });

    group('Value object behavior', () {
      test('days and equalityProperties should not be modifiable', () {
        final week = _expectWeek(Week.create([_weekDay(1), _weekDay(5)]));

        expect(() => week.days.clear(), throwsUnsupportedError);
        expect(() => week.equalityProperties.clear(), throwsUnsupportedError);
      });

      test('should not change when the input list is modified', () {
        final inputDays = [_weekDay(1), _weekDay(5)];
        final week = _expectWeek(Week.create(inputDays));

        inputDays.clear();

        expect(week.days.map((day) => day.value), [1, 5]);
      });

      test('contains should report whether a day belongs to the week', () {
        final week = _expectWeek(Week.create([_weekDay(1), _weekDay(5)]));

        expect(week.contains(_weekDay(1)), isTrue);
        expect(week.contains(_weekDay(7)), isFalse);
      });
    });
  });
}

WeekDay _weekDay(int value) {
  return WeekDay.fromInt(value).fold(
    (failure) => fail('Expected a WeekDay, got $failure.'),
    (weekDay) => weekDay,
  );
}

Week _expectWeek(AppResult<WeekFailure, Week> result) {
  return result.fold(
    (failure) => fail('Expected a Week, got $failure.'),
    (week) => week,
  );
}
