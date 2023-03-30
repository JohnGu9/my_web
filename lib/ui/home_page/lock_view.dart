import 'package:flutter/material.dart';

class LockView extends StatefulWidget {
  const LockView({super.key, required this.child});
  final Widget child;

  @override
  State<LockView> createState() => _LockViewState();
}

class _LockViewState extends State<LockView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  _unlock() {
    if (_controller.isDismissed) {
      _controller.animateTo(1, duration: const Duration(milliseconds: 600));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LockViewData(
      unlock: _unlock,
      animation: _controller,
      isLocking: !_controller.isCompleted,
      child: widget.child,
    );
  }
}

class LockViewData extends InheritedWidget {
  const LockViewData({
    super.key,
    required super.child,
    required this.unlock,
    required this.animation,
    required this.isLocking,
  });
  final void Function() unlock;
  final Animation<double> animation;
  final bool isLocking;

  @override
  bool updateShouldNotify(covariant LockViewData oldWidget) {
    return isLocking != oldWidget.isLocking;
  }
}
