import 'package:flutter/material.dart';

class SwitchTap extends StatelessWidget {
  final Size size;
  final String label;
  final void Function() onUp;
  final void Function() onDown;

  const SwitchTap({
    super.key,
    required this.size,
    required this.label,
    required this.onUp,
    required this.onDown,
  });

  Widget _iconButton({
    IconData icon = Icons.keyboard_arrow_up,
    required ThemeData theme,
    required void Function() onPressed,
  }) {
    var buttonSize = size.width * .22;

    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.onSurface,
        minimumSize: Size(buttonSize, buttonSize),
      ),
      icon: Icon(icon, color: theme.colorScheme.surface, size: size.width * .5),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.onSurface.withValues(alpha: .9),
            theme.colorScheme.onSurface.withValues(alpha: .8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.all(size.width * .15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconButton(onPressed: onUp, theme: theme),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.surface,
              fontSize: size.width * .23,
              fontWeight: FontWeight.bold,
            ),
          ),
          _iconButton(
            icon: Icons.keyboard_arrow_down,
            theme: theme,
            onPressed: onDown,
          ),
        ],
      ),
    );
  }
}
