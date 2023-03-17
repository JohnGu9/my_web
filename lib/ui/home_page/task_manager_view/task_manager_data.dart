import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class TaskManagerData extends InheritedWidget {
  const TaskManagerData({
    super.key,
    required super.child,
    required this.enter,
    this.appData,
    Duration? hideWidgetDuration,
  }) : hideWidgetDuration = hideWidgetDuration ?? Duration.zero;

  final void Function(AppData data) enter;
  final AppData? appData;
  final Duration hideWidgetDuration;

  @override
  bool updateShouldNotify(covariant TaskManagerData oldWidget) {
    return appData != oldWidget.appData;
  }
}

enum FlyStats {
  enter,
  exit,
}

class FlyAnimation {
  const FlyAnimation({
    required this.flyStats,
    required this.hideWidgetDuration,
  });
  final Duration hideWidgetDuration;
  final FlyStats flyStats;
}

enum TaskManagerStats {
  enter,
  enterApp,
  drag,
  exit,
}
