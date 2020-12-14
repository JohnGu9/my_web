import 'package:flutter/material.dart';

class DialogTransition extends StatelessWidget {
  const DialogTransition({
    Key key,
    this.animation,
    this.secondaryAnimation,
    this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
            color: ColorTween(begin: Colors.transparent, end: Colors.black38)
                .evaluate(animation),
            child: child);
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          )),
          child: child,
        ),
      ),
    );
  }
}
