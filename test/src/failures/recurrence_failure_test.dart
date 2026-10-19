import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('RecurrenceFailure', () {
    group('Failure types & values', () {
      test('failures should retain their constructor values', () {
        final startDate = DateTime(2026, 2, 1);
        final endDate = DateTime(2026, 1, 1);

        expect(
          InvalidRangeRecurrenceFailure(
            startDateTime: startDate,
            endDateTime: endDate,
          ).equalityProperties,
          [startDate, endDate],
        );
        expect(const InvalidIntervalRecurrenceFailure(interval: 0).interval, 0);
      });
    });

    group('Immutability', () {
      test('equalityProperties should not be modifiable', () {
        final failures = <RecurrenceFailure>[
          InvalidRangeRecurrenceFailure(
            startDateTime: DateTime(2026, 2, 1),
            endDateTime: DateTime(2026, 1, 1),
          ),
          const InvalidIntervalRecurrenceFailure(interval: 0),
        ];

        for (final failure in failures) {
          expect(
            () => failure.equalityProperties.clear(),
            throwsUnsupportedError,
          );
        }
      });
    });
  });
}
