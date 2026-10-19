import 'failure.dart';

sealed class YearFailure extends Failure {
  final int yearValue;
  const YearFailure({required this.yearValue});

  @override
  List<Object?> get equalityProperties => List.unmodifiable([yearValue]);
}

// ========== Invalid Year Failure ==========
class InvalidYearFailure extends YearFailure {
  const InvalidYearFailure({required super.yearValue});
}
