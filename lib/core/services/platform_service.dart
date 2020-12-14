import 'package:flutter/material.dart';
import 'package:my_web/core/native/native_channel.dart';

class PlatformService extends StatefulWidget {
  static _PlatformService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PlatformService>();
  }

  const PlatformService({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _PlatformServiceState createState() => _PlatformServiceState();
}

class _PlatformServiceState extends State<PlatformService> {
  Future<bool> _future;
  @override
  void didChangeDependencies() {
    _future = NativeChannel.of(context).isMobile;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const SizedBox();
        return _PlatformService(
          isMobile: snapshot.data,
          child: widget.child,
        );
      },
    );
  }
}

class _PlatformService extends InheritedWidget {
  const _PlatformService({Key key, Widget child, @required this.isMobile})
      : super(key: key, child: child);

  final bool isMobile;

  @override
  bool updateShouldNotify(covariant _PlatformService oldWidget) {
    return isMobile != oldWidget.isMobile;
  }
}
