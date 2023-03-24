import 'package:flutter/material.dart';

class FlyBackPositioned extends StatefulWidget {
  const FlyBackPositioned({
    super.key,
    required this.child,
    required this.start,
    required this.end,
    required this.onEnd,
  });
  final Rect start;
  final Rect end;
  final void Function() onEnd;
  final Widget child;

  @override
  State<FlyBackPositioned> createState() => _FlyBackPositionedState();
}

class _FlyBackPositionedState extends State<FlyBackPositioned>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Rect?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )
      ..addStatusListener((status) {
        if (_controller.isCompleted) {
          widget.onEnd();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _controller.animateTo(1, curve: Curves.linearToEaseOut);

    _animation =
        RectTween(begin: widget.start, end: widget.end).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant FlyBackPositioned oldWidget) {
    if (widget.end != oldWidget.end) {
      _animation = Tween<Rect>(begin: _animation.value, end: widget.end)
          .animate(_controller);
      _controller.value = 0;
      _controller.animateTo(1, curve: Curves.linearToEaseOut);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (!_controller.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onEnd();
      });
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _animation.value!,
      child: widget.child,
    );
  }
}
