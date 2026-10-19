import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group(
    'AppEquatable',
    () {
      group(
        'Equality',
        () {
          test(
            'should compare instances using equalityProperties',
            () {
              expect(const _TestEquatable(1), const _TestEquatable(1));
              expect(const _TestEquatable(1), isNot(const _TestEquatable(2)));
              expect(const _TestEquatable(1).hashCode,
                  const _TestEquatable(1).hashCode);
            },
          );
        },
      );

      group(
        'String representation',
        () {
          test(
            'stringify should be enabled and toString should include props',
            () {
              final instance = _TestEquatable(1);

              expect(instance.stringify, isTrue);
              expect(instance.toString(), contains('1'));
            },
          );
        },
      );

      group(
        'Immutability',
        () {
          test(
            'props should match equalityProperties and not be modifiable',
            () {
              final instance = _TestEquatable(1);

              expect(instance.props, [1]);
              expect(() => instance.props.add(2), throwsUnsupportedError);
            },
          );
        },
      );
    },
  );
}

class _TestEquatable extends AppEquatable {
  final int value;

  const _TestEquatable(this.value);

  @override
  List<Object?> get equalityProperties => [value];
}
