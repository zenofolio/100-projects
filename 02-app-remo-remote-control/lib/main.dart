import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remo/application/common/helpers/navigate.dart';
import 'package:remo/application/data/adapters/samsung/samsung.dart';
import 'package:remo/application/di/app_scope.dart';
import 'package:remo/application/modules/connect/connect.dart';
import 'package:remo/application/ui/screens/connect/views/find_devices.dart';
import 'package:remo/application/ui/screens/device/views/device_view.dart';
import 'package:remo/application/ui/theme.dart';

import 'application/common/constants/arguments.dart';
import 'application/modules/connect/models/device_adapter.dart';
import 'application/navigation/route_paths.dart';
import 'application/ui/screens/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  AppScope.register(Connect(
    factories: [
      SamsungDeviceAdapter.factory
    ]
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: RoutePaths.home,
      routes: {
        RoutePaths.home: (ctx) => const HomeView(),
        RoutePaths.discovery: (ctx) => const FindDevicesView(),
        RoutePaths.device: (ctx) => Navigation.requireArg<DeviceAdapter>(
          ctx,
          key: ArgsConstants.device,
          failback: RoutePaths.discovery,
          builder: (device) => DeviceView(device: device),
        ),
      },
    );
  }
}
