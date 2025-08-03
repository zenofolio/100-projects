import 'package:flutter/material.dart';


class LightColors {
  static const primary = Color(0xFF1DA1F2); // Azul Remo
  static const secondary = Color(0xFFFF7F3F); // Naranja “o”
  static const background = Color(0xFFF2F9FF); // Azul claro pastel
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFEF5350);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF000000);
  static const onBackground = Color(0xFF101010);
  static const onSurface = Color(0xFF222222);
  static const onError = Color(0xFFFFFFFF);
}

class DarkColors {
  static const primary = Color(0xFF1DA1F2); // Azul Remo
  static const secondary = Color(0xFFFF7F3F); // Naranja “o”
  static const background = Color(0xFF0D0E11); // Casi negro
  static const surface = Color(0xFF1B1D22);
  static const error = Color(0xFFCF6679);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFF000000);
  static const onBackground = Color(0xFFE0E0E0);
  static const onSurface = Color(0xFFE0E0E0);
  static const onError = Color(0xFF000000);
}




final kPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    LightColors.primary.withValues(
        alpha: .4
    ),
    LightColors.primary,
  ],
);





