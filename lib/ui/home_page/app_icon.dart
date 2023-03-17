import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

import 'task_manager_view/task_manager_app_card.dart';
import 'task_manager_view/task_manager_data.dart';

/// also view: [TaskManagerAppCard]

class AppIcon extends StatefulWidget {
  const AppIcon({super.key, required this.data});
  static const borderRadius = BorderRadius.all(Radius.circular(12));
  final AppData data;

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: AppIcon.borderRadius,
            color: Colors.black.withOpacity(_controller.value * 0.28),
          ),
          child: child,
        );
      },
      child: _StackHero(
        appData: widget.data,
        controller: _controller,
      ),
    );
  }
}

class _StackHero extends StatelessWidget {
  const _StackHero({required this.appData, required this.controller});
  final AppData appData;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<TaskManagerData>()!;
    return AnimatedOpacity(
      opacity: data.appData == appData ? 0 : 1,
      duration: data.hideWidgetDuration,
      child: GestureDetector(
        onTapDown: (details) {
          controller.animateTo(1);
        },
        onTapUp: (details) {
          controller.animateBack(0);
          final data =
              context.dependOnInheritedWidgetOfExactType<TaskManagerData>();
          data?.enter(appData);
        },
        onTapCancel: () {
          controller.animateBack(0);
        },
        child: SizedBox(
          height: 64,
          width: 64,
          child: Material(
            key: appData.iconKey,
            elevation: data.appData == appData ? 0 : 2,
            animationDuration: Duration.zero,
            borderRadius: AppIcon.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(child: appData.iconBackground),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: appData.icon,
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
