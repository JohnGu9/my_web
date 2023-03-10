import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';
import 'package:my_web/ui/home_page/drag_bar.dart';

class TaskManagerAppCard extends StatefulWidget {
  /// also view: [AppIcon]
  const TaskManagerAppCard({
    super.key,
    required this.biggest,
    required this.appData,
    required this.reenterApp,
    required this.reenterEnable,
    required this.delta,
    required this.showDragBar,
    required this.isFlyAnimation,
    required this.isFocus,
    required this.isEnterTaskManager,
    required this.isEnterApp,
    required this.updateSizeFactor,
    required this.removeApp,
  });
  final bool? isFlyAnimation;
  final AppData appData;
  final Size biggest;
  final bool reenterEnable;
  final void Function() reenterApp;
  final bool isEnterTaskManager;
  final bool showDragBar;
  final double delta;
  final bool isFocus;
  final bool isEnterApp;
  final void Function(double value) updateSizeFactor;
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
      value: widget.isFlyAnimation == true ? 0 : 1,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        setState(() {});
      });
    _controller.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant TaskManagerAppCard oldWidget) {
    if (widget.isFlyAnimation != oldWidget.isFlyAnimation) {
      if (widget.isFlyAnimation == null || widget.isFlyAnimation == true) {
        _controller.animateTo(1);
      } else {
        _controller.animateBack(0);
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Material(
            elevation: Tween<double>(begin: 0, end: 4).evaluate(_controller),
            animationDuration: Duration.zero,
            borderRadius: borderRadius,
            child: ClipRRect(
              borderRadius: borderRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _controller.value == _controller.upperBound
                          ? const AlwaysStoppedAnimation(0)
                          : const AlwaysStoppedAnimation(1),
                      child: widget.appData.iconBackground,
                    ),
                  ),
                  Positioned.fill(
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
                  ),
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _controller,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: SizedBox.fromSize(
                            size: widget.biggest,
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
                  if (widget.reenterEnable)
                    Positioned.fill(
                      child: _Dismissible(
                        isEnterTaskManager: widget.isEnterTaskManager,
                        reenterApp: widget.reenterApp,
                        biggest: widget.biggest,
                        updateSizeFactor: widget.updateSizeFactor,
                        removeApp: widget.removeApp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        _tag,
      ],
    );
  }

  Widget get _tag {
    final opacity = (3 + widget.delta).clamp(0.0, 1.0);
    return Positioned(
      top: -48,
      left: 0,
      height: 42,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(opacity),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      clipBehavior: Clip.antiAlias,
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
                const SizedBox(width: 8),
                Text(
                  widget.appData.name,
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity((1 - widget.delta.abs()).clamp(0, 1)),
                    fontSize: 16,
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
    }
    if (!widget.isFocus) {
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
            child: RawImage(
              image: image,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.medium,
            ),
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
              child: AnimatedOpacity(
                duration: Duration.zero,
                opacity: (1 - widget.delta.abs()).clamp(0, 1),
                child: DragBar(
                  show: widget.showDragBar,
                ),
              ),
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
    required this.biggest,
    required this.updateSizeFactor,
    required this.removeApp,
  });
  final void Function() reenterApp;
  final bool isEnterTaskManager;
  final Size biggest;
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
      value: 0,
      upperBound: 1,
      lowerBound: -1,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        widget.updateSizeFactor(_controller.value);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.reenterApp,
      onVerticalDragUpdate:
          widget.isEnterTaskManager ? _onVerticalDragUpdate : null,
      onVerticalDragEnd: widget.isEnterTaskManager ? _onVerticalDragEnd : null,
      child: const Center(),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _controller.value += details.delta.dy / widget.biggest.height;
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
