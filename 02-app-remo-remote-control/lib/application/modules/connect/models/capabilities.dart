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

/// Capability for remote control navigation (D-Pad)
abstract class DirectionalPadCapability extends Capability {
  const DirectionalPadCapability({
    required super.enabled,
    required super.supported,
    required super.available,
  });

  Future<void> keyUp();

  Future<void> keyDown();

  Future<void> keyLeft();

  Future<void> keyRight();
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
  const PowerManagementCapability({
    required super.enabled,
    required super.supported,
    required super.available,
  });

  Future<void> powerOn() async {
    throw UnimplementedError('powerOn() is not implemented');
  }

  Future<void> powerOff() async {
    throw UnimplementedError('powerOff() is not implemented');
  }
}

/// Capability for streaming apps (Netflix, YouTube, etc.)
abstract class StreamingCapability extends Capability {
  const StreamingCapability({
    required super.enabled,
    required super.supported,
    required super.available,
  });

  Future<void> launchApp(String appId) async {
    throw UnimplementedError('launchApp() is not implemented');
  }
}
