import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

import 'layout_desktop/layout_desktop.dart' as Desktop;
import 'layout_mobile/layout_mobile.dart' as Mobile;

class PlatformHomePage extends StatelessWidget {
  const PlatformHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformService.of(context).isMobile;
    return isMobile ? const Mobile.HomePage() : const Desktop.HomePage();
  }
}
