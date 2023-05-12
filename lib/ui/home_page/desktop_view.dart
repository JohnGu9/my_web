import 'package:flutter/material.dart';

import 'package:my_web/ui/apps/app_store.dart';
import 'package:my_web/ui/apps/books.dart';
import 'package:my_web/ui/apps/calender.dart';
import 'package:my_web/ui/apps/camera.dart';
import 'package:my_web/ui/apps/clock.dart';
import 'package:my_web/ui/apps/find_my.dart';
import 'package:my_web/ui/apps/home.dart';
import 'package:my_web/ui/apps/mail.dart';
import 'package:my_web/ui/apps/maps.dart';
import 'package:my_web/ui/apps/message.dart';
import 'package:my_web/ui/apps/notes.dart';
import 'package:my_web/ui/apps/other.dart';
import 'package:my_web/ui/apps/phone.dart';
import 'package:my_web/ui/apps/photos.dart';
import 'package:my_web/ui/apps/reminders.dart';
import 'package:my_web/ui/apps/settings.dart';
import 'package:my_web/ui/apps/stocks.dart';
import 'package:my_web/ui/apps/wallet.dart';
import 'package:my_web/ui/apps/weather.dart';
import 'package:my_web/ui/apps/zafari.dart';
import 'package:my_web/ui/home_page/desktop_view/re_layout.dart';
import 'package:my_web/ui/other_apps/about.dart';
import 'package:my_web/ui/other_apps/google.dart';
import 'package:my_web/ui/other_apps/google_translate.dart';
import 'package:my_web/ui/other_apps/reddit.dart';
import 'package:my_web/ui/other_apps/spotify.dart';
import 'package:my_web/ui/other_apps/telegram.dart';
import 'package:my_web/ui/other_apps/twitch.dart';
import 'package:my_web/ui/other_apps/youtube.dart';

import 'desktop_view/layout_view.dart';

final orderData = ReLayoutOrderData([
  [
    Calender.appData,
    Photos.appData,
    Mail.appData,
    Clock.appData,
    Notes.appData,
    Stocks.appData,
    Weather.appData,
    Reminders.appData,
    Maps.appData,
    AppStore.appData,
    Home.appData,
    Books.appData,
    FindMy.appData,
    Wallet.appData,
    Settings.appData,
  ],
  [
    Youtube.appData,
    Spotify.appData,
    Google.appData,
    GoogleTranslate.appData,
    Reddit.appData,
    Twitch.appData,
    Telegram.appData,
    Other.appData,
    About.appData,
  ],
], [
  Phone.appData,
  Message.appData,
  Zafari.appData,
  Camera.appData,
]);

class DesktopView extends StatelessWidget {
  const DesktopView({super.key, required this.constraints});
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ReLayout(
      data: orderData,
      child: LayoutView(constraints: constraints),
    );
  }
}
