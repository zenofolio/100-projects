import 'package:flutter/material.dart';

enum AnimateDirection { bottom, top, left, right, none }

class AnimateFrom extends StatefulWidget {
  final Widget child;
  final AnimateDirection direction;
  final bool fade;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double offset;

  const AnimateFrom({
    super.key,
    required this.child,
    this.direction = AnimateDirection.none,
    this.fade = true,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.offset = 20.0,
  });

  @override
  State<AnimateFrom> createState() => _AnimateFromState();
}

class _AnimateFromState extends State<AnimateFrom> {
  bool _visible = false;

  Offset get _beginOffset {
    final dx = switch (widget.direction) {
      AnimateDirection.left => -widget.offset,
      AnimateDirection.right => widget.offset,
      _ => 0.0,
    };
    final dy = switch (widget.direction) {
      AnimateDirection.top => -widget.offset,
      AnimateDirection.bottom => widget.offset,
      _ => 0.0,
    };
    return Offset(dx, dy);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : _beginOffset / MediaQuery.of(context).size.shortestSide,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedOpacity(
        opacity: _visible && widget.fade ? 1.0 : (widget.fade ? 0.0 : 1.0),
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
