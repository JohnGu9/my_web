import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class Google extends StatelessWidget {

  const Google({super.key});
  static final appData = AppData(
    app: const Google(),
    icon: const Icon(
      Icons.question_mark,
      color: Colors.blue,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Google',
  );

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://www.google.com/"));
  }
}
