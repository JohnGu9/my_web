import 'package:flutter/material.dart';

typedef Widget AnimationBuilder(
    BuildContext context, AnimationController controller, Widget? child);

class AnimationControllerBuilder extends StatefulWidget {
  const AnimationControllerBuilder({
    Key? key,
    required this.builder,
    this.child,
    this.duration,
    this.reverseDuration,

    // the value below should be constant
    this.initialValue,
    this.debugLabel,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);

  final Widget? child;
  final AnimationBuilder builder;

  final double? initialValue;
  final Duration? duration;
  final Duration? reverseDuration;
  final String? debugLabel;
  final double lowerBound;
  final double upperBound;
  final AnimationBehavior animationBehavior;

  @override
  _AnimationControllerBuilderState createState() =>
      _AnimationControllerBuilderState();
}

class _AnimationControllerBuilderState extends State<AnimationControllerBuilder>
    with SingleTickerProviderStateMixin<AnimationControllerBuilder> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.initialValue,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      debugLabel: widget.debugLabel,
      lowerBound: widget.lowerBound,
      upperBound: widget.upperBound,
      animationBehavior: widget.animationBehavior,
    );
  }

  @override
  void didUpdateWidget(AnimationControllerBuilder oldWidget) {
    assert(() {
      if (widget.debugLabel != _controller.debugLabel ||
          widget.animationBehavior != _controller.animationBehavior ||
          widget.lowerBound != _controller.lowerBound ||
          widget.upperBound != _controller.upperBound)
        throw ArgumentError(
            'Some property of [AnimationController] can\'t change after [initState]');
      return true;
    }());
    _controller.duration = widget.duration;
    _controller.reverseDuration = widget.reverseDuration;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller, widget.child);
  }
}
