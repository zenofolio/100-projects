import 'dart:async';
import 'dart:convert';

import '../mixin/adapter_capabilities.dart';
import '../mixin/adapter_status.dart';

import 'capabilities.dart';
import 'device_apps.dart';

abstract class DeviceAdapter
    with AdapterCapabilities<Capability>, DeviceStatusMixin {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String? ipAddress;
  final List<DeviceApp> installedApps;
  final Map<String, dynamic> metadata;

  DeviceAdapter({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.installedApps,
    this.ipAddress,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  Future<void> configure(Map<String, dynamic> options);

  Future<bool> connect([String? pin]);

  Future<void> disconnect();

  Future<bool> isConnected();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'ipAddress': ipAddress,
      'capabilities': capabilities.map((c) => c.toMap()).toList(),
      'installedApps': installedApps.map((a) => a.toMap()).toList(),
      'isCurrentlyConnected': isCurrentlyConnected,
      'metadata': metadata,
    };
  }

  @override
  String toString() => jsonEncode(toMap());

  void dispose() {
    disposeStatus();
  }
}
