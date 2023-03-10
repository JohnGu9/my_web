import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/data/assets.dart';
import 'package:my_web/ui/widgets/temp_focus_node.dart';

import 'drag_bar.dart';

class NotificationBar extends StatelessWidget {
  static const statusBarHeight = 20.0;
  const NotificationBar(
      {super.key, required this.child, required this.constraints});
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
  late TempFocusNode _focusNode;

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

  _close() {
    _focusNode.unfocus();
    _controller.animateBack(0, curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 450),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });
    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
    _focusNode = TempFocusNode();
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
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const _CloseIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _CloseIntent(),
      },
      child: Actions(
        actions: {
          _CloseIntent: _CloseAction(_close),
        },
        child: Stack(
          children: [
            const Positioned.fill(
              child: Image(
                image: Assets.background,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: widget.child,
            ),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: NotificationBar.statusBarHeight,
              child: _StatusBar(showTime: true),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Tween<double>(
                begin: 0,
                end: widget.constraints.maxHeight,
              ).transform(_controller.value),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: Tween<double>(
                begin: widget.constraints.maxHeight -
                    NotificationBar.statusBarHeight,
                end: 0,
              ).transform(_controller.value),
              height: 100,
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: _handlePointerDown,
              ),
            ),
          ],
        ),
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
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: constraints.maxHeight,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 20 * (1 - animation.value),
              sigmaY: 20 * (1 - animation.value),
            ),
            child: const Image(
              image: Assets.background,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: constraints.maxHeight,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.1, 0.6),
            ),
            child: _FullBar(showDragBar: showDragBar),
          ),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.signal_cellular_alt),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.wifi),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.battery_full),
            ),
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

class _CloseIntent extends Intent {
  const _CloseIntent();
}

class _CloseAction extends Action<_CloseIntent> {
  _CloseAction(this.close);

  final void Function() close;

  @override
  void invoke(covariant _CloseIntent intent) => close();
}

class _TimeView extends StatefulWidget {
  const _TimeView();

  @override
  State<_TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<_TimeView> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 60 - _now.second), () {
      setState(() {
        _now = DateTime.now();
      });
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {
          _now = DateTime.now();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        "${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}");
  }
}

class _Weekday extends StatelessWidget {
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

  const _Weekday();

  @override
  Widget build(BuildContext context) {
    return Text(toWeekdayString(DateTime.now().weekday));
  }
}
