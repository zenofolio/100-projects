import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remo/application/common/helpers/navigate.dart';
import 'package:remo/application/ui/screens/connect/views/find_devices.dart';
import 'package:remo/application/ui/screens/device/views/device_view.dart';
import 'package:remo/application/ui/theme.dart';

import 'application/navigation/route_paths.dart';
import 'application/ui/screens/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        RoutePaths.home: (ctx) => HomeView(),
        RoutePaths.discovery: (ctx) => FindDevicesView(),
        RoutePaths.device: (ctx) => DeviceView(device: extractDevice(ctx, fallback: RoutePaths.discovery)!)
      },
      initialRoute: RoutePaths.home,
    );
  }
}
