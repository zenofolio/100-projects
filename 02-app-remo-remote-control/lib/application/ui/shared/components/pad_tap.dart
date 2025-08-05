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
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: .5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          )
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
                      Center(
                        child: Container(
                          width: constraints.maxWidth * .45,
                          height: constraints.maxWidth * .45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 1
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  theme.scaffoldBackgroundColor,
                                  theme.colorScheme.surface.withValues(alpha: .3),
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              )
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => widget.enter?.call(),
                              child: Center(
                                child: Text("OK", style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: constraints.maxWidth * .07,
                                    color: theme.highlightColor
                                )),
                              ),
                            ),
                          ),
                        ),
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
