import 'package:dlna_dart/dlna.dart';
import 'package:remo/application/data/adapters/samsung/samsung_socket.dart';
import 'package:remo/application/modules/connect/models/capabilities.dart';
import 'package:remo/application/modules/connect/models/device_adapter.dart';
import 'package:remo/application/modules/connect/models/device_status.dart';

import 'constants.dart';

class SamsungDeviceAdapter extends DeviceAdapter {
  late final SamsungSocket socket;

  /////////////////////////////
  /// Constructor
  /////////////////////////////

  SamsungDeviceAdapter({
    required super.id,
    required super.name,
    required super.model,
    super.brand = "samsung",
    super.ipAddress,
    super.installedApps = const [],
  }) {
    socket = SamsungSocket(this);
  }

  /////////////////////////////
  /// Configuration & Connection
  /////////////////////////////

  @override
  Future<void> configure(Map<String, dynamic> options) async {}

  @override
  Future<bool> connect([String? pin]) async {
    setStatus(DeviceStatus.connecting);

    try {
      await socket.connect();

      if (socket.isConnected) {
        clearCapability();
        addCapabilities([
          RemoteControlCapability(
            supported: true,
            available: true,
            enabled: true,
            onBack: () async => socket.sendKey(SamsungKeyConstants.back),
            onEnter: () async => socket.sendKey(SamsungKeyConstants.enter),
            onHome: () async => socket.sendKey(SamsungKeyConstants.home),
            onUp: () async => socket.sendKey(SamsungKeyConstants.up),
            onDown: () async => socket.sendKey(SamsungKeyConstants.down),
            onLeft: () async => socket.sendKey(SamsungKeyConstants.left),
            onRight: () async => socket.sendKey(SamsungKeyConstants.right),
            onMenu: () async => socket.sendKey(SamsungKeyConstants.menu),
          ),
          VolumeControlCapability(
            supported: true,
            available: true,
            enabled: true,
            volumeDown:
                () async => socket.sendKey(SamsungKeyConstants.volumeDown),
            volumeUp: () async => socket.sendKey(SamsungKeyConstants.volumeUp),
            mute: () async => socket.sendKey(SamsungKeyConstants.mute),
          ),
        ]);

        setStatus(DeviceStatus.connected);
        return true;
      }
    } catch (_) {}

    setStatus(DeviceStatus.disconnected);
    return false;
  }

  @override
  Future<void> delete() async {
    await socket.disconnect();
  }

  @override
  Future<void> disconnect() async {
    socket.dispose();
  }

  @override
  Future<bool> isConnected() =>
      Future.value(socket.status == DeviceStatus.connected);

  /////////////////////////////
  /// Factory Constructor
  /////////////////////////////

  static DeviceAdapter? factory(String id, DLNADevice device) {
    if (!device.info.friendlyName.toLowerCase().contains("samsung")) {
      return null;
    }

    final uri = Uri.parse(device.info.URLBase);
    final ip = uri.host;

    return SamsungDeviceAdapter(
      id: id,
      name: device.info.friendlyName,
      model: "samsung",
      installedApps: [],
      ipAddress: ip,
    );
  }
}
