import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group(
    'AppResult',
    () {
      group(
        'Construction & state',
        () {
          test(
            'left should report a failure state',
            () {
              const result = AppResult<String, int>.left('failure');

              expect(result.isLeft, isTrue);
              expect(result.isRight, isFalse);
            },
          );

          test(
            'right should report a success state',
            () {
              const result = AppResult<String, int>.right(42);

              expect(result.isLeft, isFalse);
              expect(result.isRight, isTrue);
            },
          );

          test(
            'should support nullable payloads',
            () {
              const left = AppResult<String?, int>.left(null);
              const right = AppResult<String, int?>.right(null);

              expect(left.fold((value) => value, (_) => 'unexpected'), isNull);
              expect(right.fold((_) => 'unexpected', (value) => value), isNull);
            },
          );
        },
      );

      group(
        'Folding',
        () {
          test(
            'left should call only onLeft and return its value',
            () {
              const result = AppResult<String, int>.left('failure');

              final value = result.fold(
                (failure) => 'handled $failure',
                (_) => fail('onRight should not be called for a left result.'),
              );

              expect(value, 'handled failure');
            },
          );

          test(
            'right should call only onRight and return its value',
            () {
              const result = AppResult<String, int>.right(42);

              final value = result.fold(
                (_) => fail('onLeft should not be called for a right result.'),
                (success) => 'handled $success',
              );

              expect(value, 'handled 42');
            },
          );
        },
      );
    },
  );
}
