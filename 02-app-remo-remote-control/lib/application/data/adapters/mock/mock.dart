import 'package:remo/application/modules/connect/models/capabilities.dart';
import 'package:remo/application/modules/connect/models/device_adapter.dart';
import 'package:remo/application/modules/connect/models/device_apps.dart';
import 'package:remo/application/modules/connect/models/device_status.dart';

class MockDeviceAdapter extends DeviceAdapter {
  bool _connected = false;

  MockDeviceAdapter({
    required super.id,
    required super.name,
    required super.model,
    super.brand = "mock",
    super.ipAddress,
    super.installedApps = const [],
  }) {
    // Add all capabilities as enabled and available
    addCapabilities([
      RemoteControlCapability(
        supported: true,
        available: true,
        enabled: true,
        onBack: () async {},
        onEnter: () async {},
        onHome: () async {},
        onUp: () async {},
        onDown: () async {},
        onLeft: () async {},
        onRight: () async {},
        onMenu: () async {},
      ),
      VolumeControlCapability(
        supported: true,
        available: true,
        enabled: true,
        volumeUp: () async {},
        volumeDown: () async {},
        mute: () async {},
      ),
    ]);
  }

  @override
  Future<void> configure(Map<String, dynamic> options) async {
    // No-op for mock
  }

  @override
  Future<bool> connect([String? pin]) async {
    setStatus(DeviceStatus.connecting);
    await Future.delayed(const Duration(milliseconds: 100));
    _connected = true;
    setStatus(DeviceStatus.connected);
    return true;
  }

  @override
  Future<void> disconnect() async {
    setStatus(DeviceStatus.disconnected);
    _connected = false;
  }

  @override
  Future<bool> isConnected() async {
    return _connected;
  }

  static DeviceAdapter factory(String id) {
    return MockDeviceAdapter(
      id: id,
      name: 'Mock Device',
      model: 'MockModel',
      installedApps: const [
        DeviceApp(name: 'MockApp1'),
        DeviceApp(name: 'MockApp2'),
      ],
    );
  }

  /// Simulated factory for DLNADevice or similar device objects
  static DeviceAdapter factoryFromDLNA(String id, dynamic device) {
    // device can be any type, just simulate mapping
    return MockDeviceAdapter(
      id: id,
      name: 'Mock Device',
      model: 'MockModel',
      ipAddress: '0.0.0.0',
      installedApps: const [
        DeviceApp(name: 'MockApp1'),
        DeviceApp(name: 'MockApp2'),
      ],
    );
  }
}
