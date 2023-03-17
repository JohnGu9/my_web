import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class Maps extends StatelessWidget {

  const Maps({super.key});
  static final appData = AppData(
    app: const Maps(),
    icon: const Icon(
      Icons.map,
      color: Colors.white,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.green,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Maps',
  );

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://www.google.com/maps/"));
  }
}
