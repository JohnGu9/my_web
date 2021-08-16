import 'package:flutter/material.dart';

class PageRouteAnimation extends InheritedWidget {
  static PageRouteAnimation of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PageRouteAnimation>()!;
  }

  const PageRouteAnimation(
      {required Widget child,
      required this.animation,
      required this.secondaryAnimation})
      : super(child: child);
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  @override
  bool updateShouldNotify(covariant PageRouteAnimation oldWidget) {
    return oldWidget.animation != animation ||
        oldWidget.secondaryAnimation != secondaryAnimation;
  }
}
