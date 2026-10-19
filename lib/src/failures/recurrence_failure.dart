import 'package:bits_domain_core/bits_domain_core.dart';

sealed class RecurrenceFailure extends Failure {
  const RecurrenceFailure();
}

// ========== Invalid Range Failure ==========
class InvalidRangeRecurrenceFailure extends RecurrenceFailure {
  final DateTime startDateTime;
  final DateTime endDateTime;

  const InvalidRangeRecurrenceFailure({
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  List<Object?> get equalityProperties =>
      List.unmodifiable([startDateTime, endDateTime]);
}

// ========== Invalid Interval Failure ==========
class InvalidIntervalRecurrenceFailure extends RecurrenceFailure {
  final int interval;

  const InvalidIntervalRecurrenceFailure({required this.interval});

  @override
  List<Object?> get equalityProperties => List.unmodifiable([interval]);
}
