import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group(
    'MonthFailure',
    () {
      group(
        'Failure types & values',
        () {
          test(
            'BelowRangeMonthFailure should retain the invalid value',
            () {
              const failure = BelowRangeMonthFailure(monthValue: 0);

              expect(failure.monthValue, 0);
              expect(failure, const BelowRangeMonthFailure(monthValue: 0));
            },
          );

          test(
            'AboveRangeMonthFailure should retain the invalid value',
            () {
              const failure = AboveRangeMonthFailure(monthValue: 13);

              expect(failure.monthValue, 13);
              expect(
                failure,
                const AboveRangeMonthFailure(monthValue: 13),
              );
            },
          );
        },
      );

      group(
        'Immutability',
        () {
          test(
            'equalityProperties should not be modifiable',
            () {
              const failure = BelowRangeMonthFailure(monthValue: 0);

              expect(
                () => failure.equalityProperties.add(1),
                throwsUnsupportedError,
              );
            },
          );
        },
      );
    },
  );
}
