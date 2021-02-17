import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

mixin RouteControllerMixin<T extends StatefulWidget> on State<T> {
  @protected
  AnimationController get controller;
  @protected
  SpringDescription get spring;
  @protected
  FocusScopeNode get focusScopeNode;

  late ValueNotifier<bool> onRouteChanged;
  late double _targetValue;
  LocalHistoryEntry? _historyEntry;

  void _ensureHistoryEntry() {
    onRouteChanged.value = true;
    if (_historyEntry == null) {
      final route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(focusScopeNode);
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    onRouteChanged.value = false;
    _historyEntry = null;
    close();
  }

  void open() {
    _targetValue = 1.0;
    controller.animateWith(SpringSimulation(
        spring, controller.value, _targetValue, controller.velocity));
  }

  void close() {
    _targetValue = 0.0;
    controller.animateWith(SpringSimulation(
        spring, controller.value, _targetValue, controller.velocity));
  }

  bool get isOpened {
    return _targetValue == 1.0;
  }

  bool get isClosed {
    return !isOpened;
  }

  void routeListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        if (_targetValue == 0.0) {
          _historyEntry?.remove();
          _historyEntry = null;
        } else {
          _ensureHistoryEntry();
        }

        break;
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    onRouteChanged = ValueNotifier(false);
  }

  @override
  void dispose() {
    onRouteChanged.dispose();
    super.dispose();
  }
}
