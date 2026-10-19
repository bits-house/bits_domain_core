import 'package:meta/meta.dart';

/// A base class for functional error handling using the Either pattern.
///
/// Usage:
/// ```dart
/// final result = AppResult<int, String>.right("Success");
/// final message = AppResult.fold(
///   (left) => "Failure: $left",
///   (right) => "Success: $right",
/// );
/// ```
@immutable
class AppResult<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  /// Creates a Failure (Left) state.
  const AppResult.left(L failure)
      : _left = failure,
        _right = null,
        _isLeft = true;

  /// Creates a Success (Right) state.
  const AppResult.right(R success)
      : _left = null,
        _right = success,
        _isLeft = false;

  /// Executes one of the provided functions based on the current state.
  /// [onLeft] is executed if the state is a failure.
  /// [onRight] is executed if the state is a success.
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return _isLeft ? onLeft(_left as L) : onRight(_right as R);
  }

  /// Returns true if this instance represents a Failure (Left).
  bool get isLeft => _isLeft;

  /// Returns true if this instance represents a Success (Right).
  bool get isRight => !_isLeft;
}
