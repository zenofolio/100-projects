import 'package:flutter/cupertino.dart';
import 'package:remo/application/modules/connect/adapters/device_adapter.dart';

void navigate(
    BuildContext context,
    String path, [
      Map<String, dynamic> args = const {},
    ]) {
  Navigator.pushNamed(context, path, arguments: args.isEmpty ? null : args);
}

void goToDevicePage(
    BuildContext context,
    String route, {
      required DeviceAdapter device,
    }) =>
    navigate(context, route, {"device": device});

DeviceAdapter? extractDevice(
    BuildContext ctx, {
      String? fallback,
    }) {
  final args = ModalRoute.of(ctx)?.settings.arguments;
  if (args is Map && args['device'] is DeviceAdapter) {
    return args['device'] as DeviceAdapter;
  }

  if (fallback != null) {
    Navigator.pushReplacementNamed(ctx, fallback);
  }

  return null;
}
