import 'dart:async';

import 'package:flutter/material.dart' hide DragTarget;
import 'package:my_web/ui/home_page/desktop_view/re_layout.dart';
import 'package:my_web/ui/widgets/drag_target.dart';

class PageSwitchDragTarget extends StatelessWidget {
  const PageSwitchDragTarget({
    super.key,
    required this.horizontalPadding,
    required this.child,
    required this.controller,
    required this.pageCount,
  });
  final double horizontalPadding;
  final Widget child;
  final PageController controller;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final enable = context
        .dependOnInheritedWidgetOfExactType<ReLayoutData>()
        ?.positionData is ReLayoutDragPositionData;
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (enable)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: horizontalPadding,
            child: _DragTarget(
              delay: const Duration(milliseconds: 450),
              repeatDelay: const Duration(milliseconds: 900),
              onWillAccept: () {
                if ((controller.page ?? controller.initialPage) >= 1) {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        if (enable)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: horizontalPadding,
            child: _DragTarget(
              delay: const Duration(milliseconds: 450),
              repeatDelay: const Duration(milliseconds: 900),
              onWillAccept: () {
                if ((controller.page ?? controller.initialPage) <=
                    (pageCount - 2)) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}

class _DragTarget extends StatefulWidget {
  const _DragTarget(
      {required this.delay,
      required this.onWillAccept,
      required this.repeatDelay});
  final Duration delay;
  final Duration repeatDelay;
  final void Function() onWillAccept;

  @override
  State<_DragTarget> createState() => _DragTargetState();
}

class _DragTargetState extends State<_DragTarget> {
  Timer? _timer;

  _timerCallback() {
    widget.onWillAccept();
    _timer = Timer(widget.repeatDelay, _timerCallback);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return const Center();
      },
      onWillAccept: (data) {
        _timer = Timer(widget.delay, _timerCallback);
        return true;
      },
      onLeave: (details) {
        _timer?.cancel();
      },
    );
  }
}
