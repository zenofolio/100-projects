import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/device_status.dart';

mixin DeviceStatusMixin {
  DeviceStatus _status = DeviceStatus.disconnected;
  final StreamController<DeviceStatus> _statusStream = StreamController.broadcast();

  DeviceStatus get status => _status;
  Stream<DeviceStatus> get connectionStatus => _statusStream.stream;
  bool get isCurrentlyConnected => _status == DeviceStatus.connected;

  @protected
  void setStatus(DeviceStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      _statusStream.add(newStatus);
    }
  }

  @mustCallSuper
  void disposeStatus() {
    _statusStream.close();
  }
}