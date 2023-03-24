import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_web/ui/home_page/desktop_view/touch_protect.dart';

import 're_layout.dart';

class PageSwitchDragTarget extends StatelessWidget {
  const PageSwitchDragTarget({
    super.key,
    required this.horizontalPadding,
    required this.child,
    required this.controller,
    required this.pageIndex,
    required this.pageCount,
  });
  final double horizontalPadding;
  final Widget child;
  final PageController controller;
  final int pageIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final reLayout = context.dependOnInheritedWidgetOfExactType<ReLayoutData>();
    final protect =
        context.dependOnInheritedWidgetOfExactType<TouchProtectData>();
    final enable = reLayout?.positionData is ReLayoutDragPositionData &&
        protect?.enable != false;
    return Row(
      children: [
        SizedBox(
          width: horizontalPadding,
          height: double.infinity,
          child: enable && pageIndex != 0
              ? _DragTarget(
                  delay: const Duration(milliseconds: 450),
                  onWillAccept: () {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.ease,
                    );
                  },
                )
              : null,
        ),
        Expanded(child: child),
        SizedBox(
          width: horizontalPadding,
          height: double.infinity,
          child: enable && pageIndex != pageCount - 1
              ? _DragTarget(
                  delay: const Duration(milliseconds: 450),
                  onWillAccept: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.ease,
                    );
                  },
                )
              : null,
        ),
      ],
    );
  }
}

class _DragTarget extends StatefulWidget {
  const _DragTarget(
      {super.key, required this.delay, required this.onWillAccept});
  final Duration delay;
  final void Function() onWillAccept;

  @override
  State<_DragTarget> createState() => _DragTargetState();
}

class _DragTargetState extends State<_DragTarget> {
  Timer? _timer;

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
        _timer = Timer(widget.delay, () {
          widget.onWillAccept();
        });
        return true;
      },
      onLeave: (details) {
        _timer?.cancel();
      },
    );
  }
}
