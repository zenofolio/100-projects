import 'package:flutter/material.dart';

const _padIconsColor = Colors.grey;

class PadTap extends StatefulWidget {
  final void Function()? up, down, left, right, enter;

  const PadTap({
    super.key,
    this.up,
    this.down,
    this.left,
    this.right,
    this.enter,
  });

  @override
  State<PadTap> createState() => _PadTapState();
}

class _PadTapState extends State<PadTap> {
  Offset _startPosition = Offset.zero;
  bool visibility = false;

  final size = 50.0;

  Widget _icon(
    double size,
    IconData icon,
    Alignment alignment,
    Color color, [
    void Function()? onPress,
    ButtonStyle? style,
  ]) {
    return Align(
      alignment: alignment,
      child: IconButton(
        padding: EdgeInsets.all(13),
        icon: Icon(icon, size: size, color: color),
        onPressed: onPress,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = theme.colorScheme.onSurface;

    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: theme.cardColor.withValues( alpha: .3),
          borderRadius: BorderRadius.circular(300),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final _iconSize = constraints.maxWidth * .18;

            return Stack(
              children: [
                // Icon layer
                Padding(
                  padding: EdgeInsets.all(constraints.maxWidth * .01),
                  child: Stack(
                    children: [
                      _icon(
                        _iconSize,
                        Icons.circle_rounded,
                        Alignment.center,
                        color,
                        widget.enter,
                        IconButton.styleFrom(
                          padding: EdgeInsets.all(30),
                          shape: RoundedRectangleBorder(
                             side: BorderSide(
                               width: 1,
                               color: theme.scaffoldBackgroundColor
                             ),
                            borderRadius: BorderRadius.circular(100)
                          )
                        )
                      ),
                      _icon(
                        _iconSize,
                        Icons.keyboard_arrow_up,
                        Alignment.topCenter,
                        color,
                        widget.up,
                      ),
                      _icon(
                        _iconSize,
                        Icons.keyboard_arrow_down,
                        Alignment.bottomCenter,
                        color,
                        widget.down,
                      ),
                      _icon(
                        _iconSize,
                        Icons.keyboard_arrow_left,
                        Alignment.centerLeft,
                        color,
                        widget.left,
                      ),
                      _icon(
                        _iconSize,
                        Icons.keyboard_arrow_right,
                        Alignment.centerRight,
                        color,
                        widget.right,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PadPainter extends CustomPainter {
  final ThemeData theme;

  _PadPainter(this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = theme.cardColor
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = theme.colorScheme.secondary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Background circle
    canvas.drawCircle(center, size.width / 2, paint);

    // Optional: directional lines
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      borderPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
