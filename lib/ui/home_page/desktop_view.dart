import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/apps/app_store.dart';
import 'package:my_web/ui/apps/books.dart';
import 'package:my_web/ui/apps/find_my.dart';
import 'package:my_web/ui/apps/home.dart';
import 'package:my_web/ui/apps/maps.dart';
import 'package:my_web/ui/apps/reminders.dart';
import 'package:my_web/ui/apps/stocks.dart';
import 'package:my_web/ui/apps/wallet.dart';
import 'package:my_web/ui/apps/weather.dart';
import 'package:my_web/ui/apps/zafari.dart';
import 'package:my_web/ui/apps/calender.dart';
import 'package:my_web/ui/apps/camera.dart';
import 'package:my_web/ui/apps/clock.dart';
import 'package:my_web/ui/apps/mail.dart';
import 'package:my_web/ui/apps/message.dart';
import 'package:my_web/ui/apps/notes.dart';
import 'package:my_web/ui/apps/other.dart';
import 'package:my_web/ui/apps/phone.dart';
import 'package:my_web/ui/apps/photos.dart';
import 'package:my_web/ui/apps/settings.dart';
import 'package:my_web/ui/other_apps/google.dart';
import 'package:my_web/ui/other_apps/google_translate.dart';
import 'package:my_web/ui/other_apps/reddit.dart';
import 'package:my_web/ui/other_apps/spotify.dart';
import 'package:my_web/ui/other_apps/telegram.dart';
import 'package:my_web/ui/other_apps/twitch.dart';
import 'package:my_web/ui/other_apps/youtube.dart';

import 'app_icon.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({super.key, required this.constraints});
  final BoxConstraints constraints;

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  late PageController _controller;
  var _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _page)
      ..addListener(() {
        final page = _controller.page;
        if (page != null) {
          final p = page.round();
          if (p != _page) {
            setState(() {
              _page = p;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pages = 3;
    final theme = Theme.of(context);
    final data = MediaQuery.of(context);

    final gridHeight =
        widget.constraints.maxHeight - data.padding.top - 112 - 32;
    final gridWidth = widget.constraints.maxWidth;
    final gridRows = min((gridHeight / 89).floor(), 4);
    final gridColumns = (gridWidth / 160).floor().clamp(4, 6);
    return Focus(
      autofocus: true,
      child: _TouchProtect(
        child: Column(
          children: [
            SizedBox(height: data.padding.top),
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  _Grid(
                    rows: gridRows,
                    columns: gridColumns,
                    data: [
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
                  ),
                  _Grid(
                    rows: gridRows,
                    columns: gridColumns,
                    data: [
                      Youtube.appData,
                      Spotify.appData,
                      Google.appData,
                      GoogleTranslate.appData,
                      Reddit.appData,
                      Twitch.appData,
                      Telegram.appData,
                      Other.appData,
                    ],
                  ),
                  const _About(),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  shape: const StadiumBorder(),
                  child: SizedBox(
                    height: 24,
                    width: 21.0 * pages,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < pages; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(_page == i ? 1 : 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: theme.colorScheme.surface.withOpacity(0.70),
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  child: _TouchProtect(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: AppIcon(data: Phone.appData),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: AppIcon(data: Message.appData),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: AppIcon(data: Zafari.appData),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: AppIcon(data: Camera.appData),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TouchProtect extends StatefulWidget {
  const _TouchProtect({required this.child});
  final Widget child;

  @override
  State<_TouchProtect> createState() => _TouchProtectState();
}

class _TouchProtectState extends State<_TouchProtect> {
  var _enable = true;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          setState(() {
            _enable = false;
          });
        } else if (notification is ScrollEndNotification) {
          setState(() {
            _enable = true;
          });
        }
        return false;
      },
      child: _TouchProtectData(
        enable: _enable,
        child: widget.child,
      ),
    );
  }
}

class _TouchProtectData extends InheritedWidget {
  const _TouchProtectData({
    required super.child,
    required this.enable,
  });
  final bool enable;

  @override
  bool updateShouldNotify(covariant _TouchProtectData oldWidget) {
    return enable != oldWidget.enable;
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.rows, required this.columns, required this.data});
  final List<AppData> data;
  final int rows;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final enable =
        context.dependOnInheritedWidgetOfExactType<_TouchProtectData>()?.enable;
    return IgnorePointer(
      ignoring: enable == false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int row = 0; row < rows; row++)
            SizedBox(
              height: 89,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (int col = 0; col < columns; col++)
                    _itemBuilder(row * columns + col)
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _itemBuilder(int index) {
    if (index >= data.length) return const SizedBox(width: 64);
    final d = data[index];
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          AppIcon(
            data: d,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              d.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _About extends StatelessWidget {
  const _About();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AppIcon(
            child: SizedBox(
              height: 64,
              width: 64,
              child: Material(
                elevation: 2,
                animationDuration: Duration.zero,
                borderRadius: AppIcon.borderRadius,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: Colors.white),
                    ),
                    const Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: FlutterLogo(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "About",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _AppIcon extends StatefulWidget {
  const _AppIcon({required this.child});
  final Widget child;

  @override
  State<_AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<_AppIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: AppIcon.borderRadius,
            color: Colors.black.withOpacity(_controller.value * 0.28),
          ),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (details) {
          _controller.animateTo(1);
        },
        onTapUp: (details) {
          _controller.animateBack(0);
          showAboutDialog(
              context: context,
              applicationName: "My Web",
              applicationIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FlutterLogo(),
              ),
              applicationVersion: "@JohnGu9");
        },
        onTapCancel: () {
          _controller.animateBack(0);
        },
        child: widget.child,
      ),
    );
  }
}
