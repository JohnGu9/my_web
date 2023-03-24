import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';
import 'package:my_web/ui/home_page/drag_bar.dart';
import 'task_manager_data.dart';

/// also view: [AppIcon]

class TaskManagerAppCard extends StatefulWidget {
  const TaskManagerAppCard({
    super.key,
    required this.constraints,
    required this.appData,
    required this.reenterApp,
    required this.delta,
    required this.showDragBar,
    required this.flyStats,
    required this.isFocus,
    required this.isEnterTaskManager,
    required this.updateSizeFactor,
    required this.removeApp,
    required this.isEnterApp,
    required this.reenterEnable,
    required this.sizeFactor,
  });
  final FlyStats? flyStats;
  final AppData appData;
  final BoxConstraints constraints;
  final double delta;
  final bool isEnterTaskManager;
  final bool isEnterApp;
  final bool isFocus;
  final bool showDragBar;
  final bool reenterEnable;
  final double sizeFactor;
  final void Function(double value) updateSizeFactor;
  final void Function() reenterApp;
  final void Function() removeApp;

  @override
  State<TaskManagerAppCard> createState() => _TaskManagerAppCardState();
}

class _TaskManagerAppCardState extends State<TaskManagerAppCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.flyStats == FlyStats.enter ? 0 : 1,
      duration: const Duration(milliseconds: 150),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });
    _controller.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant TaskManagerAppCard oldWidget) {
    if (widget.flyStats != oldWidget.flyStats) {
      switch (widget.flyStats) {
        case FlyStats.exit:
          _controller.animateBack(0);
          break;
        default:
          _controller.animateTo(1);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = Tween(
      begin: AppIcon.borderRadius,
      end: BorderRadius.zero,
    ).evaluate(_controller);
    final isCompleted = _controller.isCompleted;
    final size = widget.constraints.biggest;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Material(
        elevation: Tween<double>(begin: 0, end: 4).evaluate(_controller),
        animationDuration: Duration.zero,
        borderRadius: borderRadius,
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: !isCompleted
                  ? ClipRRect(
                      borderRadius: borderRadius,
                      clipBehavior: Clip.hardEdge,
                      child: widget.appData.iconBackground,
                    )
                  : const SizedBox(),
            ),
            Positioned.fill(
              child: !isCompleted
                  ? ClipRRect(
                      borderRadius: borderRadius,
                      clipBehavior: Clip.hardEdge,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: widget.appData.icon,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                child: SizedBox.fromSize(
                  size: size,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [_tag],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                clipBehavior: Clip.hardEdge,
                child: FadeTransition(
                  opacity: _controller,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    child: SizedBox.fromSize(
                      size: size,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: _AppView(
                          appData: widget.appData,
                          delta: widget.delta,
                          isEnterApp: widget.isEnterApp,
                          isFocus: widget.isFocus,
                          showDragBar: widget.showDragBar,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: _Dismissible(
                enable: widget.reenterEnable,
                isEnterTaskManager: widget.isEnterTaskManager,
                reenterApp: widget.reenterApp,
                constraints: widget.constraints,
                updateSizeFactor: widget.updateSizeFactor,
                removeApp: widget.removeApp,
                sizeFactor: widget.sizeFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _tag {
    final opacity = (3 + widget.delta).clamp(0.0, 1.0);
    return Positioned(
      top: -64,
      left: 0,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(opacity),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: widget.isEnterTaskManager ? 1 : 0,
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    height: 64,
                    width: 64,
                    child: Material(
                      elevation: 2,
                      animationDuration: Duration.zero,
                      borderRadius: AppIcon.borderRadius,
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          Positioned.fill(child: widget.appData.iconBackground),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: widget.appData.icon,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.appData.name,
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity((1 - widget.delta.abs()).clamp(0, 1)),
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({
    required this.appData,
    required this.delta,
    required this.isFocus,
    required this.showDragBar,
    required this.isEnterApp,
  });
  final AppData appData;
  final double delta;
  final bool isFocus;
  final bool isEnterApp;
  final bool showDragBar;

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, value: widget.isEnterApp && widget.isFocus ? 1 : 0)
      ..addStatusListener((status) {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant _AppView oldWidget) {
    if (_controller.isDismissed) {
      if (widget.isEnterApp && widget.isFocus) {
        _controller.animateTo(1, duration: const Duration(milliseconds: 200));
      }
    } else if (!widget.isFocus) {
      _controller.animateBack(0, duration: Duration.zero);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.appData.snapshot.value;
    return Container(
      color: Colors.black,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: !_controller.isCompleted
                ? FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.7, 1),
                      ),
                    ),
                    child: RawImage(
                      image: image,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.low,
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned.fill(
            child: !_controller.isDismissed
                ? FadeTransition(
                    opacity: _controller,
                    child: RepaintBoundary(
                      key: widget.appData.appKey,
                      child: widget.appData.app,
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: DragBar(show: widget.isFocus && widget.showDragBar),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dismissible extends StatefulWidget {
  const _Dismissible({
    required this.reenterApp,
    required this.isEnterTaskManager,
    required this.constraints,
    required this.updateSizeFactor,
    required this.removeApp,
    required this.sizeFactor,
    required this.enable,
  });
  final bool enable;
  final double sizeFactor;
  final bool isEnterTaskManager;
  final BoxConstraints constraints;
  final void Function() reenterApp;
  final void Function(double value) updateSizeFactor;
  final void Function() removeApp;

  @override
  State<_Dismissible> createState() => _DismissibleState();
}

class _DismissibleState extends State<_Dismissible>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.sizeFactor,
      upperBound: 1,
      lowerBound: -1,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        widget.updateSizeFactor(_controller.value);
      });
    if (widget.sizeFactor != 0) _controller.animateTo(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable) {
      if (widget.isEnterTaskManager) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.reenterApp,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: const Center(),
        );
      } else {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.reenterApp,
          child: const Center(),
        );
      }
    } else {
      return GestureDetector(
        child: const Center(),
      );
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _controller.value += details.delta.dy / widget.constraints.maxHeight;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy > -100) {
      _controller.animateTo(
        0,
        curve: Curves.linearToEaseOut,
        duration: const Duration(milliseconds: 450),
      );
    } else {
      _controller
          .animateTo(
        -1.0,
        curve: Curves.linearToEaseOut,
        duration: const Duration(milliseconds: 450),
      )
          .then((value) {
        if (_controller.value == -1.0) {
          widget.removeApp();
        }
      });
    }
  }
}
