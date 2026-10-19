import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A base class to facilitate [operator ==] and [hashCode] overrides.
/// Extends this class in any subclasses that require consistent equality and string representation.
///
/// Note: It wraps the functionality provided by the Equatable package to avoid direct use of this
/// external dependency in multiple subclasses.
/// It minimizes the boilerplate code and ensures consistent behavior across all subclasses.
@immutable
abstract class AppEquatable extends Equatable {
  const AppEquatable();

  /// The list of properties that will be used to determine whether
  /// two instances are equal and will be used in [.toString()] representation.
  /// Needs to be overridden in subclasses.
  List<Object?> get equalityProperties;

  /// [props] is used by Equatable to determine equality and hash code.
  /// [nonVirtual] method, must not be overridden in subclasses.
  @override
  @nonVirtual
  List<Object?> get props => List.unmodifiable(equalityProperties);

  /// [stringify] is used by Equatable to determine whether the string representation
  /// of the object should include its properties [props].
  /// [nonVirtual] method, must not be overridden in subclasses.
  @override
  @nonVirtual
  bool get stringify => true;
}
