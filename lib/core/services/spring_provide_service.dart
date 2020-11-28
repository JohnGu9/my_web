import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringProvideService extends InheritedWidget {
  static const _spring = SpringDescription(
    damping: 1,
    mass: 30,
    stiffness: 1,
  );

  static SpringDescription of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SpringProvideService>()
        .spring;
  }

  const SpringProvideService({
    Key key,
    Widget child,
    this.spring = _spring,
  }) : super(key: key, child: child);

  final SpringDescription spring;

  @override
  bool updateShouldNotify(covariant SpringProvideService oldWidget) {
    return spring != oldWidget.spring;
  }
}

mixin SpringProvideStateMixin<T extends StatefulWidget> on State<T> {
  SpringDescription get spring {
    return SpringProvideService.of(context);
  }
}
