import 'package:flutter/cupertino.dart';
import 'package:remo/application/modules/connect/models/device_adapter.dart';
import 'package:remo/application/ui/shared/layouts/RemoteControlLayout.dart';

class DeviceView extends StatelessWidget {

  final DeviceAdapter device;
  const DeviceView({ super.key,  required this.device});



  @override
  Widget build(BuildContext context) {
    return RemoteControlLayout(device: device);
  }

}