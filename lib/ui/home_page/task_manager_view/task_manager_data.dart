import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class TaskManagerData extends InheritedWidget {
  const TaskManagerData({
    super.key,
    required super.child,
    required this.enter,
    required this.appData,
    required this.duration,
  });

  final void Function(AppData data) enter;
  final AppData? appData;
  final Duration duration;

  @override
  bool updateShouldNotify(covariant TaskManagerData oldWidget) {
    return appData != oldWidget.appData;
  }
}
