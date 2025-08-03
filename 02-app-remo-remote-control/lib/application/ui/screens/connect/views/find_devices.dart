import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remo/application/common/helpers/navigate.dart';
import 'package:remo/application/modules/connect/adapters/device_adapter.dart';
import 'package:remo/application/modules/connect/connect.dart';
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
  final connector = Connect.instance();

  bool isLoading = true;

  DeviceAdapter? currentDevice;
  List<DeviceAdapter> adapters = [];
  StreamSubscription<List<DeviceAdapter>>? sub;

  void prepare() async {
    await connector.init();

    sub = connector.tvStream.listen((devices) {
      print("Devices $devices");
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
    connector.dispose();
    super.dispose();
  }

  @override
  void initState() {
    prepare();
    super.initState();
  }

  Widget _content() {

    if(currentDevice != null) {
      return DeviceComponent(device: currentDevice!);
    }


    if (isLoading || adapters.isEmpty) {
      return DiscoveringLoading(onBack: () {

      });
    }

    return DevicesList(list: adapters, onPress: (device){
       goToDevicePage(context, RoutePaths.device, device: device);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(
                alpha: .4
              ),
              theme.colorScheme.primary,
            ],
          )
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("Devices Discover", style: theme.textTheme.titleMedium),
              centerTitle: true,
            ),
            Flexible(child: _content()),
            Container(

              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Have problem to find device?",
                      style: theme.textTheme.titleMedium
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      ListTile(
                        visualDensity: VisualDensity.compact,
                        tileColor: theme.colorScheme.secondary,
                        style: ListTileStyle.drawer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        enabled: true,

                        title: Text(
                          "Enter address manually",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(Icons.arrow_forward_rounded),
                      ),
                      ListTile(
                        visualDensity: VisualDensity.compact,
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        enabled: true,

                        title: Text(
                          "Scan QR Code",
                          style: TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
