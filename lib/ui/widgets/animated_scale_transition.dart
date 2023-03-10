import 'package:flutter/material.dart';

class AnimatedScaleTransition extends StatefulWidget {
  const AnimatedScaleTransition(
      {super.key,
      required this.child,
      required this.scale,
      required this.duration,
      required this.curve});
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;

  @override
  State<AnimatedScaleTransition> createState() =>
      _AnimatedScaleTransitionState();
}

class _AnimatedScaleTransitionState extends State<AnimatedScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController scale;

  @override
  void initState() {
    super.initState();
    scale = AnimationController(vsync: this, value: widget.scale);
  }

  @override
  void didUpdateWidget(covariant AnimatedScaleTransition oldWidget) {
    if (widget.scale != oldWidget.scale) {
      scale.animateTo(
        widget.scale,
        duration: widget.duration,
        curve: widget.curve,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale.value,
      child: widget.child,
    );
  }
}
