import 'package:flutter/material.dart';

class PadTrack extends StatefulWidget {
  final void Function(double dx, double dy)? onPanStart;
  final void Function(double dx, double dy) onTrack;

  const PadTrack({super.key, required this.onTrack, this.onPanStart});

  @override
  State<PadTrack> createState() => _PadTrackState();
}

class _PadTrackState extends State<PadTrack> {
  Offset _startPosition = Offset.zero;
  bool visibility = false;

  final size = 50.0;

  void setPosition(Offset position, BoxConstraints constraints) {
    var ratio = size / 3;

    if (position.dy < ratio) return;
    if (position.dy > constraints.maxHeight - ratio) return;
    if (position.dx < size / 2) return;
    if (position.dx > constraints.maxWidth - size / 2) return;

    _startPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => Stack(
        children: [
          if (visibility)
            Positioned(
              width: size,
              height: size,
              top: _startPosition.dy - size / 2,
              left: _startPosition.dx - size / 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(size),
                ),
              ),
            ),
          GestureDetector(
            onPanStart: (details) {
              visibility = true;
              setPosition(details.localPosition, constraints);
              setState(() {});
            },

            onPanEnd: (details) {
              visibility = false;
              widget.onTrack(0, 0);
              setPosition(Offset.zero, constraints);
              setState(() {});
            },

            onPanUpdate: (details) {
              if (!visibility) return;
              setPosition(details.localPosition, constraints);
              setState(() {});
            },
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
