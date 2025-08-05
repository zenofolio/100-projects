import 'package:flutter/material.dart';

class Navigation {
  static void navigate(
      BuildContext context,
      String path, [
        Map<String, dynamic> args = const {},
      ]) {
    Navigator.pushNamed(context, path, arguments: args.isEmpty ? null : args);
  }

  static T? argument<T>(BuildContext context, String key) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args[key] is T) {
      return args[key] as T;
    }
    return null;
  }

  static Widget requireArg<T>(
      BuildContext context, {
        required String key,
        required String failback,
        required Widget Function(T) builder,
      }) {
    final data = argument<T>(context, key);
    if (data == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushNamed(context, failback);
        }
      });
      return const SizedBox.shrink();
    }

    return builder(data);
  }
}
