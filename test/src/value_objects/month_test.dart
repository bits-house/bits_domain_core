import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Month Value Object', () {
    group('Construction & validation', () {
      test('should create Month for all valid values (1 to 12)', () {
        for (var i = 1; i <= 12; i++) {
          final month = _expectMonth(Month.fromInt(i));
          expect(month.value, i);
        }
      });

      test('should return BelowRangeMonthFailure when value is zero', () {
        final result = Month.fromInt(0);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<BelowRangeMonthFailure>());
            expect(failure.monthValue, 0);
          },
          (_) => fail('Expected a below-range failure.'),
        );
      });

      test('should return BelowRangeMonthFailure when value is negative', () {
        final result = Month.fromInt(-5);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<BelowRangeMonthFailure>()),
          (_) => fail('Expected a below-range failure.'),
        );
      });

      test('should return AboveRangeMonthFailure when value is greater than 12',
          () {
        final result = Month.fromInt(13);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<AboveRangeMonthFailure>()),
          (_) => fail('Expected an above-range failure.'),
        );
      });

      test('should return MonthFailure for any invalid value', () {
        final invalidValues = [-100, -1, 0, 13, 99];

        for (final value in invalidValues) {
          final result = Month.fromInt(value);

          expect(result.isLeft, isTrue);
          result.fold(
            (failure) => expect(failure, isA<MonthFailure>()),
            (_) => fail('Expected a failure for $value.'),
          );
        }
      });
    });

    group('Comparison helpers', () {
      test('isBefore should behave correctly for all combinations', () {
        final jan = _expectMonth(Month.fromInt(1));
        final jun = _expectMonth(Month.fromInt(6));
        final dec = _expectMonth(Month.fromInt(12));

        expect(jan.isBefore(jun), true);
        expect(jan.isBefore(dec), true);
        expect(jun.isBefore(dec), true);

        expect(jun.isBefore(jan), false);
        expect(dec.isBefore(jun), false);
        expect(jan.isBefore(jan), false);
      });

      test('isAfter should behave correctly for all combinations', () {
        final jan = _expectMonth(Month.fromInt(1));
        final jun = _expectMonth(Month.fromInt(6));
        final dec = _expectMonth(Month.fromInt(12));

        expect(dec.isAfter(jun), true);
        expect(dec.isAfter(jan), true);
        expect(jun.isAfter(jan), true);

        expect(jan.isAfter(jun), false);
        expect(jun.isAfter(dec), false);
        expect(jan.isAfter(jan), false);
      });

      test('isSame should only return true for equal values', () {
        for (var i = 1; i <= 12; i++) {
          final a = _expectMonth(Month.fromInt(i));
          final b = _expectMonth(Month.fromInt(i));
          final c = _expectMonth(Month.fromInt(i == 12 ? 1 : i + 1));

          expect(a.isSame(b), true);
          expect(a.isSame(c), false);
        }
      });
    });

    group('Domain semantic flags', () {
      test('isFirstMonth should only be true for January', () {
        for (var i = 1; i <= 12; i++) {
          final month = _expectMonth(Month.fromInt(i));

          if (i == 1) {
            expect(month.isFirstMonth, true);
          } else {
            expect(month.isFirstMonth, false);
          }
        }
      });

      test('isLastMonth should only be true for December', () {
        for (var i = 1; i <= 12; i++) {
          final month = _expectMonth(Month.fromInt(i));

          if (i == 12) {
            expect(month.isLastMonth, true);
          } else {
            expect(month.isLastMonth, false);
          }
        }
      });
    });

    group('Domain calculations', () {
      test('maxDays should account for leap years', () {
        final february = _expectMonth(Month.fromInt(2));

        expect(february.maxDays(2024), 29);
        expect(february.maxDays(2025), 28);
      });
    });

    group('Value object behavior', () {
      test('months with same value should be equal', () {
        for (var i = 1; i <= 12; i++) {
          final a = _expectMonth(Month.fromInt(i));
          final b = _expectMonth(Month.fromInt(i));

          expect(a, equals(b));
          expect(a.hashCode, b.hashCode);
        }
      });

      test('months with different values should not be equal', () {
        final jan = _expectMonth(Month.fromInt(1));
        final feb = _expectMonth(Month.fromInt(2));

        expect(jan == feb, false);
      });

      test('Month should behave correctly in collections (Set)', () {
        final months = <Month>{
          _expectMonth(Month.fromInt(1)),
          _expectMonth(Month.fromInt(1)),
          _expectMonth(Month.fromInt(5)),
          _expectMonth(Month.fromInt(12)),
          _expectMonth(Month.fromInt(12)),
        };

        expect(months.length, 3);
      });

      test('Month should be safe to use as Map key', () {
        final map = {
          _expectMonth(Month.fromInt(1)): isNotNull,
          _expectMonth(Month.fromInt(12)): isNotNull,
        };

        expect(map[_expectMonth(Month.fromInt(1))], isNotNull);
        expect(map[_expectMonth(Month.fromInt(12))], isNotNull);
      });

      test('equalityProperties should not be modifiable', () {
        final properties = _expectMonth(Month.fromInt(1)).equalityProperties;

        expect(() => properties.add(2), throwsUnsupportedError);
      });
    });
  });
}

Month _expectMonth(AppResult<MonthFailure, Month> result) {
  return result.fold(
    (failure) => fail('Expected a Month, got $failure.'),
    (month) => month,
  );
}
