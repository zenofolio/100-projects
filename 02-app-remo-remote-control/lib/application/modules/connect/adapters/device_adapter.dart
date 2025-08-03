import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:remo/application/modules/connect/models/device_status.dart';

import '../models/capabilities.dart';
import '../models/device_apps.dart';

abstract class DeviceAdapter {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String? ipAddress;
  final Map<Type, Capability> capabilities = {};
  final List<DeviceApp> installedApps;

  /// Stream to notify when the list of capabilities changes
  final StreamController<List<Capability>> _capabilitiesController =
      StreamController.broadcast();

  DeviceAdapter({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.installedApps,
    this.ipAddress,
  });


  DeviceStatus _status = DeviceStatus.disconnected;
  DeviceStatus get status => _status;

  /// Stream to observe the connection status (true = connected, false = disconnected
  StreamController<DeviceStatus> _statusStream = StreamController.broadcast();
  Stream<DeviceStatus> get connectionStatus => _statusStream.stream;
  bool get isCurrentlyConnected => _status == DeviceStatus.connected;

  @protected
  void setStatus(DeviceStatus st){
    _status = st;
    _statusStream.add(st);
  }

  /// Emits updated capabilities list
  Stream<List<Capability>> get capabilitiesStream =>
      _capabilitiesController.stream;

  /// Stream to listen for received data (e.g., incoming messages, events)
  Stream<dynamic> get onDataReceived;

  /// Whether the device is currently connected

  /// Configure the adapter before connection (e.g., host, port)
  Future<void> configure(Map<String, dynamic> options);

  /// Establish the connection (optionally using a PIN or token)
  Future<void> connect([String? pin]);

  /// Disconnect the device
  Future<void> disconnect();

  /// Check if the connection is still alive
  Future<bool> isConnected();

  /// Try to test the connection without full pairing
  Future<bool> testConnection();

  /// Send raw data to the device
  Future<void> sendData(dynamic data);

  /// Clean up resources
  Future<void> dispose();

  /// Get a capability instance by type (e.g., RemoteControlCapability, VolumeCapability)
  T? getCapability<T extends Capability>() {
    var value = capabilities[T];
    if(value is T) return value;
    return null;
  }

  void addCapability(Capability capability) {
    capabilities[capability.runtimeType] = capability;
  }

  void removeCapability<T extends Capability>() {
    capabilities.remove(T);
  }

  void clearCapability() {
    capabilities.clear();
  }
  /// Persists data related to the device (e.g., token, settings, preferences)
  Future<void> saveData(String key, dynamic data);

  /// Loads previously saved data
  Future<dynamic> loadData(String key);

  /// Removes a previously stored key
  Future<void> removeData(String key);

  /// Internal use: update capabilities
  void emitCapabilities(List<Capability> caps) {
    _capabilitiesController.add(caps);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'ipAddress': ipAddress,
      'capabilities': capabilities.values.map((c) => c.toMap()).toList(),
      'installedApps': installedApps.map((app) => app.toMap()).toList(),
      'isCurrentlyConnected': isCurrentlyConnected,
    };
  }

  @override
  String toString() => jsonEncode(toMap());
}
