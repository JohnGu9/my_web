import 'package:flutter/material.dart';

class AnimatedSafeArea extends StatelessWidget {
  const AnimatedSafeArea({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final animatedPadding =
        EdgeInsetsTween(begin: EdgeInsets.zero, end: padding);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Padding(
            padding: animatedPadding.evaluate(animation),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
