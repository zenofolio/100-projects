import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: LightColors.background,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: LightColors.primary,
    onPrimary: LightColors.onPrimary,
    secondary: LightColors.secondary,
    onSecondary: LightColors.onSecondary,
    surface: LightColors.surface,
    onSurface: LightColors.onSurface,
    error: LightColors.error,
    onError: LightColors.onError,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: LightColors.surface,
    foregroundColor: LightColors.onSurface,
    elevation: 0,
  ),
  textTheme: Typography.blackMountainView,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightColors.primary,
      foregroundColor: LightColors.onPrimary,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: DarkColors.background,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: DarkColors.primary,
    onPrimary: DarkColors.onPrimary,
    secondary: DarkColors.secondary,
    onSecondary: DarkColors.onSecondary,
    surface: DarkColors.surface,
    onSurface: DarkColors.onSurface,
    error: DarkColors.error,
    onError: DarkColors.onError,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: DarkColors.surface,
    foregroundColor: DarkColors.onSurface,
    elevation: 0,
  ),
  textTheme: Typography.whiteMountainView,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DarkColors.primary,
      foregroundColor: DarkColors.onPrimary,
    ),
  ),
);
