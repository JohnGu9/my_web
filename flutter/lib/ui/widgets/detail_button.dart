import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_web/core/services/spring_provide_service.dart';

import 'custom_size_transition.dart';

class DetailButton extends StatefulWidget {
  const DetailButton({
    Key? key,
    this.shape = const StadiumBorder(),
    this.color,
    required this.simple,
    required this.detail,
    this.axis = Axis.horizontal,
    this.onTap,
    this.elevation = 0.0,
  }) : super(key: key);

  final double elevation;
  final ShapeBorder shape;
  final Color? color;
  final Widget simple;
  final Widget detail;
  final Axis axis;
  final Function()? onTap;

  @override
  _DetailButtonState createState() => _DetailButtonState();
}

class _DetailButtonState extends State<DetailButton>
    with SingleTickerProviderStateMixin<DetailButton> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onHover(bool value) {
    if (!mounted) return;
    final spring = SpringProvideService.of(context);
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
    final theme = Theme.of(context);
    final padding = theme.buttonTheme.padding;
    return _DetailButton(
      state: this,
      child: Material(
        elevation: widget.elevation,
        shape: widget.shape,
        color: widget.color ?? theme.toggleableActiveColor,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onHover: _onHover,
          onTap: _onTap,
          child: _buildAxis(children: [
            Padding(
              padding: padding,
              child: widget.simple,
            ),
            CustomSizeTransition(
              sizeFactor: _controller,
              axis: widget.axis,
              child: FadeTransition(
                opacity: _controller,
                child: Padding(
                  padding: padding,
                  child: DefaultTextStyle(
                    style: theme.textTheme.subtitle2!.copyWith(
                      color: theme.canvasColor,
                    ),
                    child: widget.detail,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAxis({required List<Widget> children}) {
    switch (widget.axis) {
      case Axis.horizontal:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
    }
  }
}

class _DetailButton extends InheritedWidget {
  const _DetailButton({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);
  @visibleForTesting
  final _DetailButtonState state;

  Animation<double> get animation {
    return state._controller;
  }

  @override
  bool updateShouldNotify(covariant _DetailButton oldWidget) {
    return state != oldWidget.state;
  }
}
