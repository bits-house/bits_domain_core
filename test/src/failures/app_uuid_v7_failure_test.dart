import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group(
    'AppUuidV7Failure',
    () {
      group(
        'Failure type & value',
        () {
          test(
            'InvalidFormatAppUuidV7Failure should retain the invalid UUID',
            () {
              const failure =
                  InvalidFormatAppUuidV7Failure(uuidValue: 'invalid');

              expect(failure.uuidValue, 'invalid');
              expect(failure,
                  const InvalidFormatAppUuidV7Failure(uuidValue: 'invalid'));
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
              const failure =
                  InvalidFormatAppUuidV7Failure(uuidValue: 'invalid');

              expect(() => failure.equalityProperties.clear(),
                  throwsUnsupportedError);
            },
          );
        },
      );
    },
  );
}
