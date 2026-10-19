import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('Year Value Object', () {
    // ============================================================
    /// CONSTRUCTION
    // ============================================================

    test('should create Year when value is valid', () {
      final year = _expectYear(Year.fromInt(2025));

      expect(year.value, 2025);
    });

    test('should allow current year', () {
      final currentYear = DateTime.now().year;

      final year = _expectYear(Year.fromInt(currentYear));

      expect(year.value, currentYear);
    });

    test('should allow far future years', () {
      final year = _expectYear(Year.fromInt(9999));

      expect(year.value, 9999);
    });

    test('should return InvalidYearFailure when year is zero', () {
      final result = Year.fromInt(0);

      expect(result.isLeft, isTrue);
      result.fold((failure) {
        expect(failure, isA<InvalidYearFailure>());
        expect(failure.yearValue, 0);
      }, (_) => fail('Expected an invalid-year failure.'));
    });

    test('should return InvalidYearFailure when year is negative', () {
      final result = Year.fromInt(-2025);

      expect(result.isLeft, isTrue);
      result.fold((failure) {
        expect(failure, isA<InvalidYearFailure>());
        expect(failure.yearValue, -2025);
      }, (_) => fail('Expected an invalid-year failure.'));
    });

    test('should return InvalidYearFailure for any invalid value', () {
      for (final value in [-100, -1, 0]) {
        final result = Year.fromInt(value);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) => expect(failure, isA<YearFailure>()),
          (_) => fail('Expected a failure for $value.'),
        );
      }
    });

    // ============================================================
    /// COMPARISON
    // ============================================================

    test('should correctly compare years', () {
      final earlier = _expectYear(Year.fromInt(2024));
      final later = _expectYear(Year.fromInt(2025));

      expect(earlier.isBefore(later), true);
      expect(later.isAfter(earlier), true);
    });

    test('isBefore should return false for same year', () {
      final a = _expectYear(Year.fromInt(2025));
      final b = _expectYear(Year.fromInt(2025));

      expect(a.isBefore(b), false);
    });

    test('isAfter should return false for same year', () {
      final a = _expectYear(Year.fromInt(2025));
      final b = _expectYear(Year.fromInt(2025));

      expect(a.isAfter(b), false);
    });

    // ============================================================
    /// VALUE OBJECT CONTRACT
    // ============================================================

    test('two Year objects with same value should be equal', () {
      final a = _expectYear(Year.fromInt(2030));
      final b = _expectYear(Year.fromInt(2030));

      expect(a, equals(b));
    });

    test('Year should behave correctly in a Set', () {
      final years = <Year>{
        _expectYear(Year.fromInt(2024)),
        _expectYear(Year.fromInt(2024)),
        _expectYear(Year.fromInt(2025)),
      };

      expect(years.length, 2);
    });

    test('Year should be safe to use as Map key', () {
      final map = {
        _expectYear(Year.fromInt(2024)): 'past',
        _expectYear(Year.fromInt(2025)): 'current',
      };

      expect(map[_expectYear(Year.fromInt(2024))], 'past');
      expect(map[_expectYear(Year.fromInt(2025))], 'current');
    });

    test('equalityProperties should not be modifiable', () {
      final properties = _expectYear(Year.fromInt(2025)).equalityProperties;

      expect(() => properties.add(1), throwsUnsupportedError);
    });
  });
}

Year _expectYear(AppResult<YearFailure, Year> result) {
  return result.fold(
    (failure) => fail('Expected a Year, got $failure.'),
    (year) => year,
  );
}
