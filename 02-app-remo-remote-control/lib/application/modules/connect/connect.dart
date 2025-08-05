import 'package:dlna_dart/dlna.dart';
import 'connect_container.dart';
import 'mixin/connect_core_mixin.dart';
import 'mixin/connect_device_mixin.dart';
import 'mixin/connect_state_mixin.dart';
import 'models/device_adapter.dart';

class Connect
    with
        ConnectCoreMixin,
        ConnectDeviceMixin<DeviceAdapter, DLNADevice>,
        ConnectStateMixin {
  Connect({List<AdapterFactory<DeviceAdapter, DLNADevice>>? factories}) {
    if (factories != null) container.addRegistry(factories);
  }

  Future<void> discover() async {
    await initCore(() => manager.start(), (manager) {
      processDevices(manager.deviceList);

      addListener(
        manager.devices.stream.listen((devices) {
          processDevices(devices);
        }),
      );
    }, setState);
  }

  Future<void> stop() async {
    await disposeCore(() => manager.stop(), setState);
  }
}
