import 'package:flutter/material.dart';

class TransitionBarrier extends AnimatedWidget {
  const TransitionBarrier({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key, listenable: animation);
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: animation.value < 0.999 && animation.value > 0.001,
      child: child,
    );
  }
}
