import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remo/application/common/constants/arguments.dart';
import 'package:remo/application/common/helpers/navigate.dart';
import 'package:remo/application/di/app_scope.dart';
import 'package:remo/application/modules/connect/connect.dart';
import 'package:remo/application/modules/connect/models/device_adapter.dart';
import 'package:remo/application/navigation/route_paths.dart';
import 'package:remo/application/ui/screens/connect/components/device_component.dart';

import '../components/devices_list.dart';
import '../components/discovering_loading.dart';

class FindDevicesView extends StatefulWidget {
  const FindDevicesView({super.key});

  @override
  State<StatefulWidget> createState() => _FindDevicesView();
}

class _FindDevicesView extends State<FindDevicesView> {
  bool isLoading = true;
  final connector = AppScope.get<Connect>();

  DeviceAdapter? currentDevice;
  List<DeviceAdapter> adapters = [];
  StreamSubscription<List<DeviceAdapter>>? sub;

  void prepare() async {
    await connector.discover();

    sub = connector.devicesStream.listen((devices) {
      if (devices.isEmpty) return;
      setState(() {
        isLoading = false;
        adapters = devices;
      });
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    connector.stop();
    super.dispose();
  }

  @override
  void initState() {
    prepare();
    super.initState();
  }

  Widget _content(List<DeviceAdapter>? devices) {
    if (devices == null || devices.isEmpty) {
      return DiscoveringLoading(
        onBack: () {
          Navigation.navigate(context, RoutePaths.home);
        },
      );
    }

    return DevicesList(
      list: devices,
      onPress: (device) {
        Navigation.navigate(context, RoutePaths.device, {
          ArgsConstants.device: device,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Devices Discover",
              style: theme.textTheme.titleMedium,
            ),
            centerTitle: true,
          ),
          Flexible(
            child: StreamBuilder(
              stream: connector.devicesStream,
              builder: (context, snapshot) {
                 return _content(snapshot.data);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Have problem to find device?",
                  style: theme.textTheme.titleMedium,
                ),
                Column(
                  spacing: 10,
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      tileColor: theme.colorScheme.primary,
                      style: ListTileStyle.drawer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      enabled: true,

                      title: Text(
                        "Enter address manually",
                        style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimary),
                      ),
                      trailing: Icon(Icons.arrow_forward_rounded),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      tileColor: theme.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      enabled: true,

                      title: Text(
                        "Scan QR Code",
                        style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.surface),
                      ),
                      trailing: Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
