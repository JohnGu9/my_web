import 'package:flutter/material.dart';

class ContextMenu extends StatefulWidget {
  const ContextMenu({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  _onTapDown(details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Hero(
              tag: this,
              flightShuttleBuilder: _flightShuttleBuilder,
              child: ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.5).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOutBack)),
                child: SizedBox.fromSize(
                  size: size,
                  child: widget.child,
                ),
              ),
            ),
          );
        },
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black38,
      ),
    );
  }

  static Widget _flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext) {
    final widget = flightDirection == HeroFlightDirection.push
        ? toHeroContext.widget
        : fromHeroContext.widget;
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Hero(
        tag: this,
        flightShuttleBuilder: _flightShuttleBuilder,
        child: widget.child,
      ),
    );
  }
}
