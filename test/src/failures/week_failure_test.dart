import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('WeekFailure', () {
    group('Failure types & values', () {
      test('EmptyWeekFailure should have stable value equality', () {
        const failure = EmptyWeekFailure();

        expect(failure, const EmptyWeekFailure());
        expect(failure.equalityProperties, isEmpty);
        expect(() => failure.equalityProperties.add(1), throwsUnsupportedError);
      });

      test('DuplicateDaysInWeekFailure should preserve a copy of its days', () {
        final inputDays = [_weekDay(1), _weekDay(1)];
        final failure =
            DuplicateDaysInWeekFailure(duplicateWeekDays: inputDays);

        inputDays.clear();

        expect(failure.duplicateWeekDays.map((day) => day.value), [1, 1]);
        expect(
          failure,
          DuplicateDaysInWeekFailure(
            duplicateWeekDays: [_weekDay(1), _weekDay(1)],
          ),
        );
      });
    });

    group('Immutability', () {
      test('duplicateWeekDays and equalityProperties should not be modifiable',
          () {
        final failure = DuplicateDaysInWeekFailure(
          duplicateWeekDays: [_weekDay(1), _weekDay(1)],
        );

        expect(() => failure.duplicateWeekDays.clear(), throwsUnsupportedError);
        expect(
            () => failure.equalityProperties.clear(), throwsUnsupportedError);
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
