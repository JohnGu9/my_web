import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_web/core/services/spring_provide_service.dart';

typedef AnimatedInkWellBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

class AnimatedInkWell extends StatefulWidget {
  const AnimatedInkWell(
      {Key key, @required this.builder, this.onTap, this.child})
      : super(key: key);

  final AnimatedInkWellBuilder builder;
  final Function() onTap;
  final Widget child;

  @override
  _AnimatedInkWellState createState() => _AnimatedInkWellState();
}

class _AnimatedInkWellState extends State<AnimatedInkWell>
    with
        SingleTickerProviderStateMixin<AnimatedInkWell>,
        SpringProvideStateMixin<AnimatedInkWell> {
  AnimationController _controller;

  ColorTween _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    final color = Theme.of(context).selectedRowColor;
    _colorTween =
        ColorTween(begin: color.withOpacity(0.0), end: color.withAlpha(24));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool value) {
    _controller.animateWith(SpringSimulation(
      spring,
      _controller.value,
      value ? 1.0 : 0.0,
      _controller.velocity,
    ));
  }

  Function() get _onTap {
    return widget.onTap ?? () {};
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onHover: _onHover,
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            alignment: Alignment.center,
            color: _colorTween.evaluate(_controller),
            child: child,
          );
        },
        child: widget.builder(
          context,
          _controller,
          widget.child,
        ),
      ),
    );
  }
}
