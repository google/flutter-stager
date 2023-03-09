import 'package:flutter/widgets.dart';

import '../state/environment_state.dart';

/// Signature for a function that creates an EnvironmentState-backed widget.
typedef EnvironmentControlBuilder<T> = Widget Function(
  BuildContext context,
  T? currentValue,
  Function(T) updateValue,
);

/// Provides a widget that allows interaction with an [EnvironmentState]-backed
/// variable.
abstract class EnvironmentControl<T> {
  /// Provides a widget that allows interaction with an [EnvironmentState]-backed
  /// variable.
  EnvironmentControl({
    required this.title,
    required this.stateKey,
    required this.defaultValue,
    this.onValueUpdated,
    EnvironmentState? environmentState,
  }) : _environmentState = environmentState ?? EnvironmentState.instance {
    _environmentState.setDefault(stateKey, defaultValue);
  }

  /// An optional callback to perform custom logic when the value backing this
  /// control is updated.
  final void Function(T)? onValueUpdated;

  /// The name of this control.
  final String title;

  /// The key used to store the associated value in [EnvironmentState]. The same
  /// key can be used by multiple [EnvironmentControls] to manipulate the same
  /// value.
  final String stateKey;

  /// The starting value associated with [stateKey]. The [EnvironmentState]
  /// value associated with [stateKey] will be reset to this value when
  /// [EnvironmentState.reset] is executed.
  final T defaultValue;

  /// Builds a widget that presents and manipulates the value of the environment
  /// variable keyed by [stateKey].
  Widget builder(
    BuildContext context,
    T? currentValue,
    void Function(T) updateValue,
  );

  /// The data store backing this control.
  final EnvironmentState _environmentState;

  /// A convenience function to update the value keyed by [stateKey] in
  /// [_environmentState].
  void updateValue(T newValue) {
    _environmentState.set(stateKey, newValue);
    if (onValueUpdated != null) {
      onValueUpdated!(newValue);
    }
  }

  /// The value of the environment variable keyed by [stateKey].
  T get currentValue => _environmentState.get<T>(stateKey) ?? defaultValue;

  /// Invokes [builder] with the current value keyed by [stateKey] and a
  /// callback to update that value.
  Widget build(BuildContext context) =>
      builder(context, currentValue, updateValue);
}
