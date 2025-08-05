import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:remo/application/modules/connect/models/device_status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:remo/application/common/constants/app.dart';
import 'package:web_socket_channel/status.dart' as wsStatus;

import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'models.dart';
import 'samsung.dart';

class SamsungSocket {
  ///////////////////////////
  /// Fields & State
  ///////////////////////////

  final SamsungDeviceAdapter _adapter;
  final StreamController<DeviceStatus> _statusController =
      StreamController.broadcast();

  DeviceStatus _status = DeviceStatus.disconnected;

  WebSocketChannel? _channel;
  String? _token;
  bool _isListening = false;

  ///////////////////////////
  /// Constructor
  ///////////////////////////

  SamsungSocket(this._adapter);

  ///////////////////////////
  /// Getters
  ///////////////////////////

  DeviceStatus get status => _status;

  bool get isConnected => _status == DeviceStatus.connected;

  Stream<DeviceStatus> get statusStream => _statusController.stream;

  ///////////////////////////
  /// Public Methods
  ///////////////////////////

  /// Create socket connection with samsung api
  Future<String?> connect({int retries = 3}) async {
    if (_status == DeviceStatus.connected &&
        _token?.isNotEmpty == true &&
        _channel != null) {
      return _token;
    }

    final ip = _adapter.ipAddress;
    if (ip == null) {
      _updateStatus(DeviceStatus.error);
      throw Exception("Device IP address is missing.");
    }

    _updateStatus(DeviceStatus.connecting);

    _token ??= await _getToken();

    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final result = await _prepareSocket(ip, _token);
        final newToken = result.key;
        final newChannel = result.value;

        if (newToken.isNotEmpty) {
          _token = newToken;
          _channel = newChannel;

          await _saveToken(newToken);
          _updateStatus(DeviceStatus.connected);

          _listenToSocketOnce();
          return newToken;
        }
      } catch (e) {
        if (attempt == retries) {
          _updateStatus(DeviceStatus.error);
          rethrow;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return null;
  }

  /// Disconnect device an delete saved data
  Future<void> disconnect() async {
    await Future.wait([_closeConnection(), _removeToken()]);

    _token = null;

    _updateStatus(DeviceStatus.disconnected);
  }

  /// Close connection, but keep saved data
  void dispose() {
    _closeConnection();
    _token = null;

    _updateStatus(DeviceStatus.disconnected);
  }

  void sendKey(String key) {
    if (_channel == null || !isConnected) {
      return;
    }

    _channel!.sink.add(
      jsonEncode({
        "method": "ms.remote.control",
        "params": {
          "Cmd": "Click",
          "DataOfCmd": key,
          "Option": "false",
          "TypeOfRemote": "SendRemoteKey",
        },
      }),
    );
  }

  ///////////////////////////
  /// Internal Methods
  ///////////////////////////

  Future<String?> _getToken() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString(SamsungSocketConstants.token) ?? '';
  }

  Future<void> _saveToken(String token) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(SamsungSocketConstants.token, token);
  }

  Future<void> _removeToken() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.remove(SamsungSocketConstants.token);
  }

  Future<void> _closeConnection() async {
    try {
      await _channel?.sink.close(wsStatus.goingAway);
      _channel = null;
    } catch (_) {}
  }

  void _listenToSocketOnce() {
    if (_isListening || _channel == null) return;
    _isListening = true;

    _channel!.stream.listen(
      _onMessageReceived,
      onDone: () => _updateStatus(DeviceStatus.disconnected),
      onError: (err) {
        print("[SamsungSocket] Error: $err");
        _updateStatus(DeviceStatus.error);
      },
    );
  }

  void _onMessageReceived(dynamic data) async {
    final msg = jsonDecode(data);

    final message = SamsungSocketMessage.fromJson(msg);

    switch (message) {
      case SamsungSocketMessageAuth():
        {
          _token = message.token;
          _updateStatus(DeviceStatus.connected);
        }
      case SamsungSocketMessageUnknown():
    }
  }

  void _updateStatus(DeviceStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  static Future<MapEntry<String, IOWebSocketChannel>> _prepareSocket(
    String ip,
    String? token,
  ) async {
    final appName = base64Encode(utf8.encode(AppConstants.appName));
    var url =
        'wss://$ip:8002/api/v2/channels/samsung.remote.control?name=$appName';
    if (token != null) url += "&token=$token";

    final completer = Completer<MapEntry<String, IOWebSocketChannel>>();

    try {
      final channel = IOWebSocketChannel.connect(
        Uri.parse(url),
        customClient:
            HttpClient()..badCertificateCallback = (_, __, ___) => true,
      );

      StreamSubscription? sub;
      sub = channel.stream.listen(
        (msg) {
          final message = SamsungSocketMessage.fromString(msg.toString());
          switch (message) {
            case SamsungSocketMessageAuth():
              sub?.cancel();
              completer.complete(MapEntry(message.getToken() ?? '', channel));
              return;
            case SamsungSocketMessageUnknown():
              sub?.cancel();
              completer.completeError(Exception("Timeout"));
              return;
          }
        },
        onDone: () {
          completer.completeError(Exception("Socket closed before ready"));
        },
        onError: (err) {
          completer.completeError(err);
        },
      );
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
