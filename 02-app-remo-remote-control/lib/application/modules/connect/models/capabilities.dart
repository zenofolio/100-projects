import 'package:remo/application/modules/connect/models/device_apps.dart';

/// Base class for TV capabilities.
/// Defines whether a feature is enabled, supported, and available.
sealed class Capability {
  final bool enabled;
  final bool supported;
  final bool available;

  const Capability({
    required this.enabled,
    required this.supported,
    required this.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      'enabled': enabled,
      'supported': supported,
      'available': available,
    };
  }
}

/// Capability for standard remote control operations
class RemoteControlCapability extends Capability {
  final Future<void> Function()? onEnter;
  final Future<void> Function()? onHome;
  final Future<void> Function()? onMenu;
  final Future<void> Function()? onBack;
  final Future<void> Function()? onUp;
  final Future<void> Function()? onDown;
  final Future<void> Function()? onLeft;
  final Future<void> Function()? onRight;

  const RemoteControlCapability({
    required super.enabled,
    required super.supported,
    required super.available,
    this.onEnter,
    this.onHome,
    this.onMenu,
    this.onBack,
    this.onUp,
    this.onDown,
    this.onLeft,
    this.onRight,
  });

}

/// Capability for volume control
class VolumeControlCapability extends Capability {
  final Future<void> Function()? volumeUp, volumeDown, mute;

  const VolumeControlCapability({
    required super.enabled,
    required super.supported,
    required super.available,
    this.volumeDown,
    this.volumeUp,
    this.mute
  });

  Future<void> onVolumeUp() async {
    return volumeUp?.call();
  }

  Future<void> onVolumeDown() async {
    return volumeDown?.call();
  }


  Future<void> onMute() async {
    return mute?.call();
  }


}

/// Capability for power management (turning TV on/off)
abstract class PowerManagementCapability extends Capability {

  final Future<void> Function()? onPowerOn;
  final Future<void> Function()? onPowerOff;

  const PowerManagementCapability({
    required super.enabled,
    required super.supported,
    required super.available,

    this.onPowerOn,
    this.onPowerOff,
  });

  Future<void> powerOn() async {
    return onPowerOn?.call();
  }

  Future<void> powerOff() async {
    return onPowerOff?.call();
  }
}

/// Capability for streaming apps (Netflix, YouTube, etc.)
abstract class DialCapability extends Capability {

  final Future<void> Function(String appId)? onLaunchApp;
  final Future<void> Function(String appId)? onCloseApp;
  final Future<List<DeviceApp>> Function()? onGetInstalledApps;
  final Future<void> Function(String appId)? onInstallApp;


  const DialCapability({
    required super.enabled,
    required super.supported,
    required super.available,

    this.onLaunchApp,
    this.onCloseApp,
    this.onGetInstalledApps,
    this.onInstallApp,
  });

  Future<void> launchApp(String appId) async {
    return onLaunchApp?.call(appId);
  }
  Future<void> closeApp(String appId) async {
    return onCloseApp?.call(appId);
  }

  Future<List<DeviceApp>> getInstalledApps() async {
    return onGetInstalledApps?.call() ?? [];
  }

  Future<void> installApp(String appId) async {
    return onInstallApp?.call(appId);
  }


}
