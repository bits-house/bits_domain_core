import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('WeekDay Value Object', () {
    group('Construction & validation', () {
      test('should create WeekDay for all valid values (1 to 7)', () {
        for (var i = 1; i <= 7; i++) {
          final weekDay = _expectWeekDay(WeekDay.fromInt(i));
          expect(weekDay.value, i);
        }
      });

      test('should return BelowRangeWeekDayFailure when value is zero', () {
        final result = WeekDay.fromInt(0);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<BelowRangeWeekDayFailure>());
            expect(failure.weekDayValue, 0);
          },
          (_) => fail('Expected a below-range failure.'),
        );
      });

      test('should return BelowRangeWeekDayFailure when value is negative', () {
        final result = WeekDay.fromInt(-5);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<BelowRangeWeekDayFailure>()),
          (_) => fail('Expected a below-range failure.'),
        );
      });

      test(
          'should return AboveRangeWeekDayFailure when value is greater than 7',
          () {
        final result = WeekDay.fromInt(8);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<AboveRangeWeekDayFailure>()),
          (_) => fail('Expected an above-range failure.'),
        );
      });

      test('should return WeekDayFailure for any invalid value', () {
        final invalidValues = [-100, -1, 0, 8, 99];

        for (final value in invalidValues) {
          final result = WeekDay.fromInt(value);

          expect(result.isLeft, isTrue);
          result.fold(
            (failure) => expect(failure, isA<WeekDayFailure>()),
            (_) => fail('Expected a failure for $value.'),
          );
        }
      });
    });

    group('Comparison helpers', () {
      test('isBefore should behave correctly', () {
        final monday = _expectWeekDay(WeekDay.fromInt(1));
        final thursday = _expectWeekDay(WeekDay.fromInt(4));
        final sunday = _expectWeekDay(WeekDay.fromInt(7));

        expect(monday.isBefore(thursday), true);
        expect(monday.isBefore(sunday), true);
        expect(thursday.isBefore(sunday), true);

        expect(thursday.isBefore(monday), false);
        expect(sunday.isBefore(thursday), false);
        expect(monday.isBefore(monday), false);
      });

      test('isAfter should behave correctly', () {
        final monday = _expectWeekDay(WeekDay.fromInt(1));
        final thursday = _expectWeekDay(WeekDay.fromInt(4));
        final sunday = _expectWeekDay(WeekDay.fromInt(7));

        expect(sunday.isAfter(thursday), true);
        expect(sunday.isAfter(monday), true);
        expect(thursday.isAfter(monday), true);

        expect(monday.isAfter(thursday), false);
        expect(thursday.isAfter(sunday), false);
        expect(monday.isAfter(monday), false);
      });

      test('isSame should only return true for equal values', () {
        for (var i = 1; i <= 7; i++) {
          final a = _expectWeekDay(WeekDay.fromInt(i));
          final b = _expectWeekDay(WeekDay.fromInt(i));
          final c = _expectWeekDay(WeekDay.fromInt(i == 7 ? 1 : i + 1));

          expect(a.isSame(b), true);
          expect(a.isSame(c), false);
        }
      });
    });

    group('Value object behavior', () {
      test('week days with same value should be equal', () {
        for (var i = 1; i <= 7; i++) {
          final a = _expectWeekDay(WeekDay.fromInt(i));
          final b = _expectWeekDay(WeekDay.fromInt(i));

          expect(a, equals(b));
          expect(a.hashCode, b.hashCode);
        }
      });

      test('week days with different values should not be equal', () {
        final monday = _expectWeekDay(WeekDay.fromInt(1));
        final tuesday = _expectWeekDay(WeekDay.fromInt(2));

        expect(monday == tuesday, false);
      });

      test('WeekDay should behave correctly in collections (Set)', () {
        final weekDays = <WeekDay>{
          _expectWeekDay(WeekDay.fromInt(1)),
          _expectWeekDay(WeekDay.fromInt(1)),
          _expectWeekDay(WeekDay.fromInt(4)),
          _expectWeekDay(WeekDay.fromInt(7)),
          _expectWeekDay(WeekDay.fromInt(7)),
        };

        expect(weekDays.length, 3);
      });

      test('WeekDay should be safe to use as Map key', () {
        final map = {
          _expectWeekDay(WeekDay.fromInt(1)): isNotNull,
          _expectWeekDay(WeekDay.fromInt(7)): isNotNull,
        };

        expect(map[_expectWeekDay(WeekDay.fromInt(1))], isNotNull);
        expect(map[_expectWeekDay(WeekDay.fromInt(7))], isNotNull);
      });

      test('equalityProperties should not be modifiable', () {
        final properties =
            _expectWeekDay(WeekDay.fromInt(1)).equalityProperties;

        expect(() => properties.add(2), throwsUnsupportedError);
      });
    });
  });
}

WeekDay _expectWeekDay(AppResult<WeekDayFailure, WeekDay> result) {
  return result.fold(
    (failure) => fail('Expected a WeekDay, got $failure.'),
    (weekDay) => weekDay,
  );
}
