import 'dart:async';
import 'package:dlna_dart/dlna.dart';

import '../connect_container.dart';
import '../models/device_adapter.dart';

mixin ConnectDeviceMixin<T, D> {
  final ConnectContainer<DeviceAdapter, DLNADevice> container =
      ConnectContainer([]);

  final StreamController<List<DeviceAdapter>> _deviceStreamController =
      StreamController.broadcast();

  List<DeviceAdapter> _lastDevices = [];

  Stream<List<DeviceAdapter>> get devicesStream => _deviceStreamController.stream;
  List<DeviceAdapter> devicesList() => _lastDevices;

  void setDevices(List<DeviceAdapter> devices) {
    _lastDevices = devices;
    _deviceStreamController.add(devices);
  }

  void processDevices(Map<String, DLNADevice> devices) {
    final mapped = _mapDevices(devices);
    setDevices(mapped);
  }

  List<DeviceAdapter> _mapDevices(Map<String, DLNADevice> data) {
    final list = <DeviceAdapter>[];

    for (var entry in data.entries) {
      final adapter = container.match(entry.key, entry.value);
      if (adapter != null) list.add(adapter);
    }

    return list;
  }
}
