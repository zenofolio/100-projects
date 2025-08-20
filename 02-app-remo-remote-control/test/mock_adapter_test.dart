import 'package:flutter_test/flutter_test.dart';
import 'package:remo/application/data/adapters/mock/mock.dart';
import 'package:remo/application/modules/connect/models/capabilities.dart';
import 'package:remo/application/modules/connect/models/device_apps.dart';

void main() {
  group('MockDeviceAdapter', () {
    late MockDeviceAdapter adapter;

    setUp(() {
      adapter = MockDeviceAdapter(
        id: 'mock-1',
        name: 'Test Mock',
        model: 'TestModel',
        installedApps: const [DeviceApp(name: 'App1')],
      );
    });

    test('should connect and report connected', () async {
      expect(await adapter.isConnected(), isFalse);
      final result = await adapter.connect();
      expect(result, isTrue);
      expect(await adapter.isConnected(), isTrue);
    });

    test('should disconnect and report not connected', () async {
      await adapter.connect();
      await adapter.disconnect();
      expect(await adapter.isConnected(), isFalse);
    });

    test('should have remote and volume capabilities', () {
      final remote = adapter.getCapability<RemoteControlCapability>();
      final volume = adapter.getCapability<VolumeControlCapability>();
      expect(remote, isNotNull);
      expect(volume, isNotNull);
    });

    test('factoryFromDLNA returns a valid adapter', () async {
      final mock = MockDeviceAdapter.factoryFromDLNA('mock-2', {});
      expect(mock, isA<MockDeviceAdapter>());
      expect(await mock.isConnected(), isFalse);
      await mock.connect();
      expect(await mock.isConnected(), isTrue);
    });
  });
}
