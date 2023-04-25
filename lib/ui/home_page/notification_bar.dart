import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/ui/home_page/lock_view.dart';
import 'package:my_web/ui/home_page/quick_access.dart';
import 'package:my_web/ui/widgets/simple_shortcuts.dart';
import 'package:my_web/ui/widgets/temp_focus_node.dart';
import 'package:my_web/ui/widgets/timer_builder.dart';

import 'desktop_background.dart';
import 'drag_bar.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({
    super.key,
    required this.child,
    required this.constraints,
  });
  static const statusBarHeight = 20.0;
  final Widget child;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return _NotificationBar(
      constraints: constraints,
      child: child,
    );
  }
}

class _NotificationBar extends StatefulWidget {
  const _NotificationBar({required this.child, required this.constraints});
  final Widget child;
  final BoxConstraints constraints;

  @override
  State<_NotificationBar> createState() => _NotificationBarState();
}

class _NotificationBarState extends State<_NotificationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late VerticalDragGestureRecognizer _recognizer;
  late LockViewData _lockViewData;
  final _focusNode = TempFocusNode();

  void _handleDragStart(DragStartDetails details) {}

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta! / widget.constraints.maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    final primaryVelocity = details.primaryVelocity;
    if (primaryVelocity != null && primaryVelocity.abs() > 100) {
      if (primaryVelocity > 0) {
        _focusNode.focus(context);
        _controller.animateTo(1, curve: Curves.ease);
      } else {
        _close();
      }
    } else {
      if (_controller.value > 0.5) {
        _focusNode.focus(context);
        _controller.animateTo(
          1,
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 600),
        );
      } else {
        _close();
      }
    }
  }

  void _handleDragCancel() {}

  void _handlePointerDown(PointerDownEvent event) {
    _recognizer.addPointer(event);
  }

  void _close() {
    _focusNode.unfocus();
    _controller.animateBack(0, curve: Curves.ease);
  }

  void _lockViewDataListener() {
    if (_controller.value < 0.5) {
      _lockViewData.unlock();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 450),
    );
    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void didChangeDependencies() {
    _lockViewData = context.dependOnInheritedWidgetOfExactType<LockViewData>()!;
    if (_lockViewData.status != AnimationStatus.completed) {
      _controller.addListener(_lockViewDataListener);
    } else {
      _controller.removeListener(_lockViewDataListener);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _recognizer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleShortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): _close,
        LogicalKeySet(LogicalKeyboardKey.escape): _close,
      },
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: NotificationBar.statusBarHeight,
            child: _StatusBar(showTime: true),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: Tween<double>(
                  begin: 0,
                  end: widget.constraints.maxHeight,
                ).transform(_controller.value),
                child: child!,
              );
            },
            child: Focus(
              focusNode: _focusNode,
              child: _Bar(
                animation: _controller,
                constraints: widget.constraints,
                recognizer: _recognizer,
                showDragBar: !_controller.isDismissed,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: Tween<double>(
                  begin: widget.constraints.maxHeight -
                      NotificationBar.statusBarHeight,
                  end: 0,
                ).transform(_controller.value),
                height: 100,
                child: child!,
              );
            },
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _handlePointerDown,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar(
      {required this.constraints,
      required this.animation,
      required this.recognizer,
      required this.showDragBar});
  final BoxConstraints constraints;
  final Animation<double> animation;
  final VerticalDragGestureRecognizer recognizer;
  final bool showDragBar;

  @override
  Widget build(BuildContext context) {
    final background = context
        .dependOnInheritedWidgetOfExactType<DesktopBackgroundData>()!
        .background;
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: constraints.maxHeight,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.linearToEaseOut,
            ),
            child: background,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: constraints.maxHeight,
          child: ClipRect(
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 30 * (1 - animation.value),
                      sigmaY: 30 * (1 - animation.value),
                    ),
                    child: const Center(),
                  );
                }),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: constraints.maxHeight,
          child: _FullBar(showDragBar: showDragBar),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.showTime});
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final quickAccessOpened =
        context.dependOnInheritedWidgetOfExactType<QuickAccessData>()?.opened;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: IconTheme(
        data: IconTheme.of(context).copyWith(size: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showTime) const _TimeView() else const Text("My Carrier"),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.near_me),
            ),
            const Expanded(child: Center()),
            if (quickAccessOpened != true) ...const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.signal_cellular_alt),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.wifi),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.battery_full),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FullBar extends StatelessWidget {
  const _FullBar({required this.showDragBar});
  final bool showDragBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 56),
                        SizedBox(
                          height: 32,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: DefaultTextStyle(
                              style: theme.textTheme.labelSmall ??
                                  const TextStyle(),
                              child: const _Weekday(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 96,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: DefaultTextStyle(
                              style: theme.textTheme.labelLarge ??
                                  const TextStyle(),
                              child: const _TimeView(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "John's zPhone",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Material(
                      color: theme.colorScheme.surface.withOpacity(0.12),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.photo_camera),
                      ),
                    ),
                    const Expanded(child: Center()),
                    Material(
                      color: theme.colorScheme.surface.withOpacity(0.12),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flashlight_on),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: DragBar(
                  show: showDragBar,
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: NotificationBar.statusBarHeight,
          child: _StatusBar(showTime: false),
        ),
      ],
    );
  }
}

class _TimeView extends StatelessWidget {
  const _TimeView();

  static Duration beforeNextMinutes() {
    final now = DateTime.now();
    return Duration(seconds: 60 - now.second);
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder(
      delay: beforeNextMinutes,
      periodic: const Duration(minutes: 1),
      builder: (now) {
        return Text(
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}");
      },
    );
  }
}

class _Weekday extends StatelessWidget {
  const _Weekday();
  static String toWeekdayString(int i) {
    switch (i) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Sunday";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(toWeekdayString(DateTime.now().weekday));
  }
}
