import 'package:flutter/material.dart';

class AnimatedSlideTransition extends StatefulWidget {
  const AnimatedSlideTransition({
    super.key,
    required this.child,
    this.transformHitTests = true,
    required this.position,
    this.textDirection,
    required this.duration,
    required this.curve,
  });
  final Widget child;
  final Offset position;
  final Curve curve;
  final Duration duration;
  final bool transformHitTests;
  final TextDirection? textDirection;

  @override
  State<AnimatedSlideTransition> createState() =>
      _AnimatedSlideTransitionState();
}

class _AnimatedSlideTransitionState extends State<AnimatedSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Offset> _tween;

  @override
  void initState() {
    super.initState();
    _tween = Tween(begin: widget.position);
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant AnimatedSlideTransition oldWidget) {
    if (oldWidget.position != widget.position) {
      _tween = Tween(begin: _tween.evaluate(_controller), end: widget.position);
      _controller.reset();
      _controller.animateTo(1, duration: widget.duration, curve: widget.curve);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = _tween.evaluate(_controller);
    if (widget.textDirection == TextDirection.rtl) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: widget.transformHitTests,
      child: widget.child,
    );
  }
}
