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
  Future _future;
  bool _isMobile;
  bool _isIOS;
  @override
  void didChangeDependencies() {
    final channel = NativeChannel.of(context);
    _future = Future.wait([
      channel.isMobile.then((value) => _isMobile = value),
      channel.isIOS.then((value) => _isIOS = value),
    ]);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const SizedBox();
        return _PlatformService(
          state: this,
          future: _future,
          child: widget.child,
        );
      },
    );
  }
}

class _PlatformService extends InheritedWidget {
  const _PlatformService(
      {Key key, Widget child, @required this.future, this.state})
      : super(key: key, child: child);

  final Future future;
  @visibleForTesting
  final _PlatformServiceState state;

  bool get isMobile {
    return state._isMobile;
  }

  bool get isIOS {
    return state._isIOS;
  }

  @override
  bool updateShouldNotify(covariant _PlatformService oldWidget) {
    return future != oldWidget.future;
  }
}
