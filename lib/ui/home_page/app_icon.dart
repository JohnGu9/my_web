import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

import 'desktop_view/re_layout.dart';
import 'task_manager_view/task_manager_app_card.dart';
import 'task_manager_view/task_manager_data.dart';

/// also view: [TaskManagerAppCard]

class AppIcon extends StatefulWidget {
  const AppIcon({super.key, required this.data, required this.label});
  static const borderRadius = BorderRadius.all(Radius.circular(12));
  final AppData data;
  final bool label;

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reLayout =
        context.dependOnInheritedWidgetOfExactType<ReLayoutData>()!;
    final taskManager =
        context.dependOnInheritedWidgetOfExactType<TaskManagerData>()!;
    final text = FloatingIcon.createText(context, widget.data.name);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 64,
          height: 64,
          foregroundDecoration: BoxDecoration(
            borderRadius: AppIcon.borderRadius,
            color: Colors.black.withOpacity(_controller.value * 0.28),
          ),
          child: child,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          if (widget.label)
            Positioned(
              left: 0,
              right: 0,
              bottom: -20,
              child: Center(
                child: text,
              ),
            ),
          Positioned.fill(
            child: AnimatedOpacity(
              key: widget.data.iconKey,
              opacity: taskManager.appData == widget.data ? 0 : 1,
              duration: taskManager.hideWidgetDuration,
              child: GestureDetector(
                onTapDown: (details) {
                  _controller.animateTo(1);
                },
                onTapUp: (details) {
                  _controller.animateBack(0);
                  taskManager.enter(widget.data);
                },
                onTapCancel: () {
                  _controller.animateBack(0);
                },
                child: LongPressDraggable(
                  onDragStarted: () {
                    context
                        .dependOnInheritedWidgetOfExactType<
                            ReLayoutOnDragStartData>()
                        ?.onDragStart(widget.data);
                  },
                  onDragCompleted: () {
                    reLayout.submit();
                  },
                  onDraggableCanceled: (velocity, offset) {
                    reLayout.submit();
                  },
                  data: widget.data,
                  feedback: FloatingIcon(
                    key: reLayout.feedbackKey,
                    data: widget.data,
                    startSize: const Size(64, 64),
                    endSize: const Size(72, 72),
                    labelStartOpacity: widget.label ? 1 : 0,
                    labelEndOpacity: 0,
                    text: text,
                  ),
                  child: Material(
                    elevation: taskManager.appData == widget.data ? 0 : 2,
                    animationDuration: Duration.zero,
                    borderRadius: AppIcon.borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(child: widget.data.iconBackground),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: widget.data.icon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingIcon extends StatefulWidget {
  const FloatingIcon({
    super.key,
    required this.data,
    required this.startSize,
    required this.endSize,
    required this.labelStartOpacity,
    required this.labelEndOpacity,
    required this.text,
  });
  final AppData data;
  final Size startSize;
  final Size endSize;
  final double labelStartOpacity;
  final double labelEndOpacity;
  final Widget text;

  @override
  State<FloatingIcon> createState() => _FloatingIconState();

  static Widget createText(BuildContext context, String data) {
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12),
    ).build(context);
  }
}

class _FloatingIconState extends State<FloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Size _startSize;
  late double _labelStartOpacity;

  @override
  void initState() {
    super.initState();
    _startSize = widget.startSize;
    _labelStartOpacity = widget.labelStartOpacity;
    _controller = AnimationController(vsync: this);
    _controller.animateTo(
      1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale =
        Tween(begin: _startSize.width / 64, end: widget.endSize.width / 64)
            .animate(_controller);
    return ScaleTransition(
      scale: scale,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: -20,
              child: FadeTransition(
                opacity: Tween(
                        begin: _labelStartOpacity, end: widget.labelEndOpacity)
                    .animate(_controller),
                child: SlideTransition(
                  position: Tween(
                          begin: Offset(0, _labelStartOpacity - 1),
                          end: Offset(0, widget.labelEndOpacity - 1))
                      .animate(_controller),
                  child: Center(
                    child: widget.text,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Material(
                    elevation: 2 * (1 + (scale.value - 1) * 64),
                    animationDuration: Duration.zero,
                    borderRadius: AppIcon.borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: widget.data.iconBackground),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: widget.data.icon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
