import 'dart:convert';

import 'package:dlna_dart/dlna.dart';
import 'package:remo/application/modules/connect/adapters/samsung/constants.dart';
import 'package:remo/application/modules/connect/adapters/samsung/samsung_socket.dart';
import 'package:remo/application/modules/connect/models/capabilities.dart';
import 'package:remo/application/modules/connect/models/device_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../device_adapter.dart';

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
    required super.installedApps,
    super.ipAddress,
  }) {
    socket = SamsungSocket(this);
  }

  /////////////////////////////
  /// Configuration & Connection
  /////////////////////////////

  @override
  Future<void> configure(Map<String, dynamic> options) async {}

  @override
  Future<void> connect([String? pin]) async {

    setStatus(DeviceStatus.connecting);
    await socket
        .connect()
        .then((e) {
          if (socket.isConnected) {
            setStatus(DeviceStatus.connected);
            clearCapability();

            addCapability(
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
            );

            addCapability(
              VolumeControlCapability(
                supported: true,
                available: true,
                enabled: true,
                volumeDown: () async => socket.sendKey(SamsungKeyConstants.volumeDown),
                volumeUp: () async => socket.sendKey(SamsungKeyConstants.volumeUp),
                mute: () async => socket.sendKey(SamsungKeyConstants.mute),
              )
            );

            print("Camabilities ${capabilities}");

          } else {
            setStatus(DeviceStatus.disconnected);
          }
        })
        .catchError((UnsupportedError err) {
          setStatus(DeviceStatus.disconnected);
        });
  }

  @override
  Future<void> disconnect() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isConnected() {
    throw UnimplementedError();
  }

  @override
  Future<bool> testConnection() {
    throw UnimplementedError();
  }

  /////////////////////////////
  /// State & Streams
  /////////////////////////////

  @override
  Stream get onDataReceived => throw UnimplementedError();

  /////////////////////////////
  /// Capabilities
  /////////////////////////////

  /////////////////////////////
  /// Data Transmission
  /////////////////////////////

  @override
  Future<void> sendData(data) {
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    throw UnimplementedError();
  }

  /////////////////////////////
  /// Persistent Storage
  /////////////////////////////

  @override
  Future<void> saveData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(data));
  }

  @override
  Future<dynamic> loadData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    return raw != null ? jsonDecode(raw) : null;
  }

  @override
  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /////////////////////////////
  /// Factory Constructor
  /////////////////////////////

  static SamsungDeviceAdapter? factory(String id, DLNADevice device) {
    if (!device.info.friendlyName.toLowerCase().contains("samsung"))
      return null;

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
