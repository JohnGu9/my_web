import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class TaskManagerData extends InheritedWidget {
  const TaskManagerData({
    super.key,
    required super.child,
    required this.returnHome,
    required this.enter,
    required this.hideWidgetDuration,
    this.appData,
  });

  final void Function(AppData data) enter;
  final AppData? appData;
  final Duration hideWidgetDuration;
  final ValueListenable<DragEndDetails> returnHome;

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
