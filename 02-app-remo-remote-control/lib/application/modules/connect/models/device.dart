

import 'capabilities.dart';
import 'device_apps.dart';

/// Represents a Smart TV with various capabilities and installed applications.
class TV {

  final String id;
  final String brand;
  final String model;
  final String? ipAddress;
  final Map<Type,Capability> capabilities;
  final List<DeviceApp> installedApps;

  const TV({
    required this.id,
    required this.brand,
    required this.model,
    this.ipAddress,
    this.capabilities = const {},
    this.installedApps = const [],
  });


  addCapability(Capability capability) {
    capabilities[capability.runtimeType] = capability;
  }


  // /// Creates a `TV` instance from a JSON object.
  // factory TV.fromJson(Map<String, dynamic> json) {
  //   return TV(
  //     id: json['id'] as String,
  //     brand: json['brand'] as String,
  //     model: json['model'] as String,
  //     ipAddress: json['ipAddress'] as String?,
  //     capabilities: (json['capabilities'] as List<dynamic>?)
  //         ?.map((cap) => Capability.fromJson(cap as Map<String, dynamic>))
  //         .toList() ??
  //         [],
  //     installedApps: (json['installedApps'] as List<dynamic>?)
  //         ?.map((app) => TVApp.fromJson(app as Map<String, dynamic>))
  //         .toList() ??
  //         [],
  //   );
  // }
  //
  // /// Converts the `TV` instance to a JSON object.
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'brand': brand,
  //     'model': model,
  //     'ipAddress': ipAddress,
  //     'capabilities': capabilities.map((cap) => cap.toJson()).toList(),
  //     'installedApps': installedApps.map((app) => app.toJson()).toList(),
  //   };
  // }
  //
  // /// Creates a copy of this object with modified fields.
  // TV copyWith({
  //   String? id,
  //   String? brand,
  //   String? model,
  //   String? ipAddress,
  //   List<Capability>? capabilities,
  //   List<TVApp>? installedApps,
  // }) {
  //   return TV(
  //     id: id ?? this.id,
  //     brand: brand ?? this.brand,
  //     model: model ?? this.model,
  //     ipAddress: ipAddress ?? this.ipAddress,
  //     capabilities: capabilities ?? List.from(this.capabilities),
  //     installedApps: installedApps ?? List.from(this.installedApps),
  //   );
  // }
  //
  // /// Returns a readable string representation of the object.
  // @override
  // String toString() {
  //   return 'TV(id: $id, brand: $brand, model: $model, ipAddress: $ipAddress, capabilities: $capabilities, installedApps: $installedApps)';
  // }

  /// Ensures objects are compared based on values, not references.
  @override
  List<Object?> get props => [id, brand, model, ipAddress, capabilities, installedApps];
}
