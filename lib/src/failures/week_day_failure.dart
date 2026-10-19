import 'package:bits_domain_core/bits_domain_core.dart';

sealed class WeekDayFailure extends Failure {
  final int weekDayValue;
  const WeekDayFailure({required this.weekDayValue});

  @override
  List<Object?> get equalityProperties => List.unmodifiable([weekDayValue]);
}

// ========== Below Range Failure ==========
class BelowRangeWeekDayFailure extends WeekDayFailure {
  const BelowRangeWeekDayFailure({required super.weekDayValue});
}

// ========== Above Range Failure ==========
class AboveRangeWeekDayFailure extends WeekDayFailure {
  const AboveRangeWeekDayFailure({required super.weekDayValue});
}
