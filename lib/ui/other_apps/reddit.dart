import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class Reddit extends StatelessWidget {
  static final appData = AppData(
    app: const Reddit(),
    icon: const Icon(
      Icons.reddit,
      color: Colors.orange,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Reddit',
  );

  const Reddit({super.key});

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://www.reddit.com/"));
  }
}
