import 'dart:async';
import 'package:dlna_dart/dlna.dart';
import 'package:remo/application/modules/connect/adapters/device_adapter.dart';
import 'package:remo/application/modules/connect/adapters/samsung/samsung.dart';

import 'connect_container.dart';
import 'models/connect_state.dart';

class Connect {
  ///////////////////////////
  /// Fields & Singletons
  ///////////////////////////

  final _manager = DLNAManager();
  final container = ConnectContainer<DeviceAdapter, DLNADevice>([
    SamsungDeviceAdapter.factory
  ]);

  final List<StreamSubscription<dynamic>> _listeners = [];

  final StreamController<List<DeviceAdapter>> _tvStreamController =
      StreamController.broadcast();

  final StreamController<ConnectState> _stateController =
      StreamController.broadcast();

  DeviceManager? _deviceManager;
  List<DeviceAdapter> _lastDevices = [];
  ConnectState _state = ConnectStoppedState();

  // Singleton pattern
  Connect._();

  static final Connect _instance = Connect._();

  factory Connect.instance() => _instance;

  ///////////////////////////
  /// Getters
  ///////////////////////////

  Stream<List<DeviceAdapter>> get tvStream => _tvStreamController.stream;

  Stream<ConnectState> get stateStream => _stateController.stream;

  ConnectState get state => _state;

  List<DeviceAdapter> devicesList() => _lastDevices;

  ///////////////////////////
  /// Init & Stop
  ///////////////////////////

  Future init([
    List<AdapterFactory<DeviceAdapter, DLNADevice>>? factories
  ]) async {


    if(_deviceManager != null) return ;

    try {
      _deviceManager = await _manager.start();
      _setState(ConnectRunningState());
      _prepare(_deviceManager!);
    } catch (exception) {
      _setState(
        ConnectFailedState(
          error: exception is Exception ? exception : Exception('$exception'),
        ),
      );
      _deviceManager = null;
    }
  }

  Future<void> dispose() async {
    await _manager.stop();
    _deviceManager = null;

    _setState(ConnectStoppedState());
  }

  ///////////////////////////
  /// Internal Logic
  ///////////////////////////

  void _prepare(DeviceManager dManager) {

    clearListeners();

    final mapped = _mapDevices(dManager.deviceList);
    _tvStreamController.add(mapped);

    _listeners.add(
      dManager.devices.stream.listen((devices) {
        _tvStreamController.add(_mapDevices(devices));
      }),
    );
  }

  List<DeviceAdapter> _mapDevices(Map<String, DLNADevice> data) {
    List<DeviceAdapter> list = [];

    for (var entry in data.entries) {
      final adapter = container.match(entry.key, entry.value);
      if (adapter == null) continue;
      list.add(adapter);
    }

    _lastDevices = list;
    return list;
  }

  void _setState(ConnectState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void clearListeners(){
    for (var listener in _listeners) {
      listener.cancel();
    }

    _listeners.clear();
  }


}
