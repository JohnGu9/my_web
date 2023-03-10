import 'package:flutter/material.dart';

class AnimatedSizedBox extends StatefulWidget {
  const AnimatedSizedBox({
    super.key,
    required this.child,
    required this.size,
    required this.duration,
    required this.curve,
  });
  final Widget child;
  final Size size;
  final Curve curve;
  final Duration duration;

  @override
  State<AnimatedSizedBox> createState() => _AnimatedSizedBoxState();
}

class _AnimatedSizedBoxState extends State<AnimatedSizedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<Size> _tween;

  @override
  void initState() {
    super.initState();
    _tween = Tween(begin: widget.size);
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant AnimatedSizedBox oldWidget) {
    if (oldWidget.size != widget.size) {
      _tween = Tween(begin: _tween.evaluate(_controller), end: widget.size);
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
    return SizedBox.fromSize(
      size: _tween.evaluate(_controller),
      child: widget.child,
    );
  }
}
