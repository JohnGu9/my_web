import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class Twitch extends StatelessWidget {

  const Twitch({super.key});
  static final appData = AppData(
    app: const Twitch(),
    icon: Stack(
      alignment: Alignment.center,
      children: const [
        Icon(
          Icons.chat_bubble,
          color: Colors.black,
          size: 56,
        ),
        Icon(
          Icons.chat_bubble,
          color: Colors.white,
          size: 36,
        ),
      ],
    ),
    iconBackground: Container(
      color: Colors.purple,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Twitch',
  );

  @override
  Widget build(BuildContext context) {
    return WebView(uri: Uri.parse("https://www.twitch.com/"));
  }
}
