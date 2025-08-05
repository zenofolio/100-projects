import 'dart:async';

import '../models/capabilities.dart';

mixin AdapterCapabilities<T extends Capability> {


  /// Map to store capabilities by their type
  final Map<Type, Capability> _capabilities = {};

  /// Stream controller to notify listeners about changes in capabilities
  final StreamController<List<Capability>> _capabilitiesController =
      StreamController.broadcast();

  // Getters

  /// Get the list of capabilities
  get capabilities => _capabilities.values.toList();


  /// Stream to observe changes in capabilities
  Stream<List<Capability>> get capabilitiesStream =>
      _capabilitiesController.stream;

  /// Get a specific capability by type
  R? getCapability<R extends T>() {
    var value = _capabilities[R];
    if (value is R) return value as R;
    return null;
  }

  // Methods

  /// Get a specific capability by type
  void addCapability(Capability capability) {
    _capabilities[capability.runtimeType] = capability;
  }

  /// Add multiple capabilities at once
  void addCapabilities(List<Capability> capabilities) {
    for (var capability in capabilities) {
      _capabilities[capability.runtimeType] = capability;
    }
  }

  /// Notify listeners about changes in capabilities
  void removeCapability() {
    _capabilities.remove(T);
  }

  /// Notify listeners about changes in capabilities
  void clearCapability() {
    _capabilities.clear();
  }
}
