import 'package:bits_domain_core/bits_domain_core.dart';

sealed class WeekFailure extends Failure {
  const WeekFailure();
}

// ========== Empty Week Failure ==========
class EmptyWeekFailure extends WeekFailure {
  const EmptyWeekFailure();

  @override
  List<Object?> get equalityProperties => const [];
}

// ========== Duplicate Days In Week Failure ==========
class DuplicateDaysInWeekFailure extends WeekFailure {
  final List<WeekDay> duplicateWeekDays;
  DuplicateDaysInWeekFailure({required List<WeekDay> duplicateWeekDays})
      : duplicateWeekDays = List.unmodifiable(duplicateWeekDays);

  @override
  List<Object?> get equalityProperties =>
      List.unmodifiable([duplicateWeekDays]);
}
