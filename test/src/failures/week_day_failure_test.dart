import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('WeekDayFailure', () {
    group('Failure types & values', () {
      test('BelowRangeWeekDayFailure should retain the invalid value', () {
        const failure = BelowRangeWeekDayFailure(weekDayValue: 0);

        expect(failure.weekDayValue, 0);
        expect(failure, const BelowRangeWeekDayFailure(weekDayValue: 0));
      });

      test('AboveRangeWeekDayFailure should retain the invalid value', () {
        const failure = AboveRangeWeekDayFailure(weekDayValue: 8);

        expect(failure.weekDayValue, 8);
        expect(failure, const AboveRangeWeekDayFailure(weekDayValue: 8));
      });
    });

    group('Immutability', () {
      test('equalityProperties should not be modifiable', () {
        const failure = BelowRangeWeekDayFailure(weekDayValue: 0);

        expect(
            () => failure.equalityProperties.clear(), throwsUnsupportedError);
      });
    });
  });
}
