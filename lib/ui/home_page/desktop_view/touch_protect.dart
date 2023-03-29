import 'package:flutter/material.dart';

class TouchProtect extends StatefulWidget {
  const TouchProtect({super.key, required this.child});
  final Widget child;

  @override
  State<TouchProtect> createState() => _TouchProtectState();
}

class _TouchProtectState extends State<TouchProtect> {
  var _enable = true;

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      setState(() {
        _enable = false;
      });
    } else if (notification is ScrollEndNotification) {
      setState(() {
        _enable = true;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: TouchProtectData(
        enable: _enable,
        child: widget.child,
      ),
    );
  }
}

class TouchProtectData extends InheritedWidget {
  const TouchProtectData({
    super.key,
    required super.child,
    required this.enable,
  });
  final bool enable;

  @override
  bool updateShouldNotify(covariant TouchProtectData oldWidget) {
    return enable != oldWidget.enable;
  }
}
