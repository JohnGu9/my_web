import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class Youtube extends StatelessWidget {
  const Youtube({super.key});
  static final appData = AppData(
    app: const Youtube(),
    icon: const Icon(
      Icons.smart_display,
      color: Colors.red,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Youtube',
  );

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://www.youtube.com/"));
  }
}
