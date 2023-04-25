import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class GoogleTranslate extends StatelessWidget {
  const GoogleTranslate({super.key});
  static final appData = AppData(
    app: const GoogleTranslate(),
    icon: const Icon(
      Icons.g_translate,
      color: Colors.blue,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Google Translate',
  );

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://translate.google.com/"));
  }
}
