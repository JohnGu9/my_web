import 'package:flutter/material.dart';
import 'package:my_web/core/native/native_channel.dart';

import 'layout_desktop/layout_desktop.dart' as Desktop;
import 'layout_mobile/layout_mobile.dart' as Mobile;

class PlatformHomePage extends StatefulWidget {
  const PlatformHomePage({Key key, this.isReady}) : super(key: key);
  final bool isReady;

  @override
  _PlatformHomePageState createState() => _PlatformHomePageState();
}

class _PlatformHomePageState extends State<PlatformHomePage> {
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
        if (!widget.isReady || snapshot.connectionState != ConnectionState.done)
          return const SizedBox();
        final isMobile = snapshot.data;
        return isMobile ? const Mobile.HomePage() : const Desktop.HomePage();
      },
    );
  }
}
