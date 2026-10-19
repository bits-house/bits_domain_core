import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('YearFailure', () {
    group('Failure types & values', () {
      test('InvalidYearFailure should retain the invalid value', () {
        const failure = InvalidYearFailure(yearValue: -1);

        expect(failure.yearValue, -1);
        expect(failure, const InvalidYearFailure(yearValue: -1));
      });
    });

    group('Immutability', () {
      test('equalityProperties should not be modifiable', () {
        const failures = <YearFailure>[
          InvalidYearFailure(yearValue: -1),
          InvalidYearFailure(yearValue: 0),
        ];

        for (final failure in failures) {
          expect(failure.equalityProperties, [failure.yearValue]);
          expect(
            () => failure.equalityProperties.add(1),
            throwsUnsupportedError,
          );
        }
      });
    });
  });
}
