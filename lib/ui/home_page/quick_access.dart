import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_web/ui/home_page/notification_bar.dart';

class QuickAccess extends StatefulWidget {
  const QuickAccess({
    super.key,
    required this.child,
    required this.constraints,
  });
  final Widget child;
  final BoxConstraints constraints;

  @override
  State<QuickAccess> createState() => _QuickAccessState();
}

class _QuickAccessState extends State<QuickAccess>
    with SingleTickerProviderStateMixin {
  late VerticalDragGestureRecognizer _recognizer;
  late TapGestureRecognizer _tapGestureRecognizer;
  late AnimationController _controller;

  static const _max = 108.0;

  void _handleDragStart(DragStartDetails details) {}

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta!;
  }

  void _handleDragEnd(DragEndDetails details) {
    final primaryVelocity = details.primaryVelocity;
    if (primaryVelocity != null && primaryVelocity.abs() > 100) {
      if (primaryVelocity > 0) {
        _controller.animateTo(_max, curve: Curves.ease);
      } else {
        _close();
      }
    } else {
      if (_controller.value > (_max / 2)) {
        _controller.animateTo(
          _max,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        _close();
      }
    }
  }

  void _handleDragCancel() {}

  void _handlePointerDown(PointerDownEvent event) {
    _recognizer.addPointer(event);
    _tapGestureRecognizer.addPointer(event);
  }

  void _close() {
    _controller.animateBack(0, curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this)
      ..onTap = _close;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = (_controller.value / _max).clamp(0.0, 1.0);
    return Stack(
      children: [
        Positioned.fill(
          child: QuickAccessData(
            opened: _controller.value > 0,
            child: Transform.scale(
              scale: Tween<double>(begin: 1, end: 0.9).transform(p),
              child: widget.child,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 30 * p,
              sigmaY: 30 * p,
            ),
            child: const Center(),
          ),
        ),
        if (_controller.value <= 0)
          Positioned(
            right: 0,
            top: 0,
            width: 108,
            height: NotificationBar.statusBarHeight,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _handlePointerDown,
            ),
          )
        else
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _handlePointerDown,
              child: GestureDetector(
                child: FractionalTranslation(
                  translation:
                      Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
                          .transform(sqrt(
                              max(0, (_controller.value - _max) / _max / 100))),
                  child: _Buttons(
                    statusBarOpened: _controller.value >= (_max * 0.5),
                    opened: _controller.value >= _max,
                    progress: p,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Buttons extends StatefulWidget {
  const _Buttons({
    required this.opened,
    required this.statusBarOpened,
    required this.progress,
  });
  final bool opened;
  final bool statusBarOpened;
  final double progress;

  @override
  State<_Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<_Buttons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const amount = 6;
  static const totalDuration = Duration(milliseconds: 400);
  static const singleDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: totalDuration);
  }

  @override
  void didUpdateWidget(covariant _Buttons oldWidget) {
    if (widget.opened != oldWidget.opened) {
      if (widget.opened) {
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
    final p = singleDuration.inMilliseconds / totalDuration.inMilliseconds;
    final d = (1 - p) / amount;
    var index = 0;
    Animation<double> animation() {
      assert(index < amount);
      final start = d * (index++);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, start + p, curve: Curves.ease),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 360,
        height: double.infinity,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: Tween<double>(
                        begin: NotificationBar.statusBarHeight, end: 135)
                    .transform(widget.progress),
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  padding: widget.statusBarOpened
                      ? const EdgeInsets.only(left: 16, right: 16)
                      : const EdgeInsets.only(left: 16, right: 8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: -28,
                        left: 0,
                        right: 0,
                        height: 150,
                        child: AnimatedOpacity(
                          opacity: widget.statusBarOpened ? 1 : 0,
                          duration: const Duration(milliseconds: 150),
                          child: AnimatedSlide(
                            offset: widget.statusBarOpened
                                ? Offset.zero
                                : const Offset(0.02, 0),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            child: const _StatusBar(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AnimatedOpacity(
                          opacity: widget.statusBarOpened ? 0 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: AnimatedSlide(
                            offset: widget.statusBarOpened
                                ? const Offset(-0.02, 0)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            child: Transform.scale(
                              scale: Tween<double>(begin: 1, end: 2)
                                  .transform(widget.progress),
                              alignment: Alignment.bottomRight,
                              child: const _SmallStatusBar(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const _Gap(),
              Row(
                children: [
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                ],
              ),
              const _Gap(),
              Row(
                children: [
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                  Expanded(
                    child: _Background(
                      animation: animation(),
                      child: const Center(),
                    ),
                  ),
                  const _Gap(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallStatusBar extends StatelessWidget {
  const _SmallStatusBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: NotificationBar.statusBarHeight,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(size: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Expanded(child: Center()),
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
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16,
      height: 16,
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.child, required this.animation});
  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: _Animation(
        animation: animation,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Animation extends StatelessWidget {
  const _Animation({required this.child, required this.animation});
  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.0).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Gap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Material(
                shape: CircleBorder(),
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.near_me, size: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text("System service"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ],
        ),
        const _Gap(),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.signal_cellular_alt),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text("My Carrier"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.wifi),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.vpn_lock),
            ),
            Expanded(child: Center()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text("100%"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.battery_full),
            ),
          ],
        ),
        const _Gap(),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.signal_cellular_alt),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text("Other Carrier"),
            ),
            Expanded(child: Center()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.near_me),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.alarm),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.headphones),
            ),
          ],
        ),
        const _Gap(),
      ],
    );
  }
}

class QuickAccessData extends InheritedWidget {
  const QuickAccessData({
    super.key,
    required super.child,
    required this.opened,
  });
  final bool opened;

  @override
  bool updateShouldNotify(covariant QuickAccessData oldWidget) {
    return opened != oldWidget.opened;
  }
}
