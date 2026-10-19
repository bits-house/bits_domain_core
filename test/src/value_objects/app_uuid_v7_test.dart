import 'package:bits_domain_core/bits_domain_core.dart';
import 'package:test/test.dart';

void main() {
  group('AppUuidV7', () {
    group('Construction & validation', () {
      final uuidRegex = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      );

      test('instances with the same value should be equal', () {
        const uuidString = '018c2d80-5e3a-7d4d-9c21-1234567890ab';

        final id1 = _expectSuccess(AppUuidV7.fromString(uuidString));
        final id2 = _expectSuccess(AppUuidV7.fromString(uuidString));
        final id3 = _expectSuccess(
          AppUuidV7.fromString('018c2d80-5e3a-7d4d-9c21-abcdefabcdef'),
        );

        expect(id1, equals(id2));
        expect(id1.hashCode, equals(id2.hashCode));
        expect(id1, isNot(equals(id3)));
      });

      test('generate should create a valid UUID v7', () {
        final id = _expectSuccess(AppUuidV7.generate());

        expect(id.value, isNotEmpty);
        expect(uuidRegex.hasMatch(id.value), isTrue,
            reason:
                'The generated value should follow the standard UUID format');
      });

      test('generate should produce unique and sortable values', () async {
        final id1 = _expectSuccess(AppUuidV7.generate());
        await Future.delayed(const Duration(milliseconds: 2));
        final id2 = _expectSuccess(AppUuidV7.generate());

        expect(id1, isNot(equals(id2)));

        expect(id2.value.compareTo(id1.value), greaterThan(0),
            reason: 'UUID v7 should be sequential and sortable by time');
      });

      test('fromString should store a valid value', () {
        const rawValue = '018b1f3c-8c08-7e3f-9b0d-7b2f4c6e8a1d';

        final id = _expectSuccess(AppUuidV7.fromString(rawValue));

        expect(id.value, equals(rawValue));
      });

      test('equalityProperties should contain the UUID value', () {
        const value = '018c2d80-5e3a-7d4d-9c21-1234567890ab';
        final id = _expectSuccess(AppUuidV7.fromString(value));

        expect(id.equalityProperties, contains(value));
      });

      test('fromString should return failure for an invalid UUID', () {
        const invalidUuidString = 'invalid-uuid-format';
        final result = AppUuidV7.fromString(invalidUuidString);

        expect(result.isLeft, isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<InvalidFormatAppUuidV7Failure>());
            expect(failure.uuidValue, invalidUuidString);
          },
          (_) => fail('Expected invalid UUID to return a failure.'),
        );
      });
    });

    group('Value object behavior', () {
      test('equalityProperties should not be modifiable', () {
        final properties =
            _expectSuccess(AppUuidV7.generate()).equalityProperties;

        expect(() => properties.clear(), throwsUnsupportedError);
      });
    });
  });
}

AppUuidV7 _expectSuccess(AppResult<AppUuidV7Failure, AppUuidV7> result) {
  return result.fold(
    (failure) => fail('Expected success, got $failure.'),
    (value) => value,
  );
}
