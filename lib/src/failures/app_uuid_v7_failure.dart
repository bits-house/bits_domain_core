import 'package:bits_domain_core/bits_domain_core.dart';

sealed class AppUuidV7Failure extends Failure {
  final String uuidValue;
  const AppUuidV7Failure({required this.uuidValue});

  @override
  List<Object?> get equalityProperties => List.unmodifiable([uuidValue]);
}

// ========== Invalid Format Failure ==========
class InvalidFormatAppUuidV7Failure extends AppUuidV7Failure {
  const InvalidFormatAppUuidV7Failure({required super.uuidValue});
}
