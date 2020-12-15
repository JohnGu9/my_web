import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

extension SpringAnimationController on AnimationController {
  TickerFuture animationWithSpring(SpringDescription spring, double value,
      {double velocity}) {
    return animateWith(
        SpringSimulation(spring, this.value, value, velocity ?? this.velocity));
  }
}

mixin RouteAnimationController<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  AnimationController controller;
  LocalHistoryEntry _historyEntry;
  SpringDescription get spring;

  Function() _ensureHistoryEntryRemove;

  open([double velocity]) {
    _ensureHistoryEntry();
    return controller.animationWithSpring(spring, 1, velocity: velocity);
  }

  close([double velocity]) {
    _ensureHistoryEntryRemove();
    return controller.animationWithSpring(spring, 0, velocity: velocity);
  }

  void _animationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        // if (_historyEntry == null)
        //   _ensureHistoryEntry();
        // else
        //   _ensureHistoryEntryRemove();
        break;

      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        if (controller.value < 0.001)
          _ensureHistoryEntryRemove();
        else if (1.0 - controller.value < 0.001) _ensureHistoryEntry();
        break;
    }
  }

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute route = ModalRoute.of(context);
      if (route != null) {
        setState(() {
          _historyEntry =
              LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
          _ensureHistoryEntryRemove = _historyEntry.remove;
          route.addLocalHistoryEntry(_historyEntry);
        });
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    _ensureHistoryEntryRemove = () {};
    controller.animationWithSpring(spring, 0);
    _historyEntry = null;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
