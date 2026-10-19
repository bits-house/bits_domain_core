import 'package:bits_domain_core/bits_domain_core.dart';

sealed class MonthFailure extends Failure {
  final int monthValue;
  const MonthFailure({required this.monthValue});

  @override
  List<Object?> get equalityProperties => List.unmodifiable([monthValue]);
}

// ========== Below Range Failure ==========
class BelowRangeMonthFailure extends MonthFailure {
  const BelowRangeMonthFailure({required super.monthValue});
}

// ========== Above Range Failure ==========
class AboveRangeMonthFailure extends MonthFailure {
  const AboveRangeMonthFailure({required super.monthValue});
}
