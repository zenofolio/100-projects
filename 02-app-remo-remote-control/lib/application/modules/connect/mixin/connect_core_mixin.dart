import 'dart:async';
import 'package:dlna_dart/dlna.dart';
import '../models/connect_state.dart';

mixin ConnectCoreMixin {
  final DLNAManager _manager = DLNAManager();
  final List<StreamSubscription<dynamic>> _listeners = [];

  DeviceManager? _deviceManager;


  DLNAManager get manager => _manager;



  Future<DeviceManager?> initCore(
    Future<DeviceManager> Function() startFn,
    void Function(DeviceManager) onReady,
    void Function(ConnectState) setState,
  ) async {
    if (_deviceManager != null) return _deviceManager;

    try {
      _deviceManager = await startFn();
      setState(ConnectRunningState());
      onReady(_deviceManager!);
    } catch (e) {
      setState(
        ConnectFailedState(error: e is Exception ? e : Exception(e.toString())),
      );
      _deviceManager = null;
    }

    return _deviceManager;
  }

  Future<void> disposeCore(
    Future<void> Function() stopFn,
    void Function(ConnectState) setState,
  ) async {
    await stopFn();
    _deviceManager = null;
    clearListeners();
    setState(ConnectStoppedState());
  }

  void clearListeners() {
    for (var listener in _listeners) {
      listener.cancel();
    }
    _listeners.clear();
  }

  void addListener(StreamSubscription sub) {
    _listeners.add(sub);
  }
}
