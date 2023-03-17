import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Clock extends StatelessWidget {

  const Clock({super.key});
  static final appData = AppData(
    app: const Clock(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Clock',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.language),
                  label: 'World Clock',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.alarm_fill),
                  label: 'Alarm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.stopwatch_fill),
                  label: 'Stopwatch',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.timer),
                  label: 'Timer',
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return const Center();
                },
              );
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: CupertinoDynamicColor.resolve(
            CupertinoTheme.of(context).barBackgroundColor,
            context,
          ),
        )
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    const angle = (pi / 180) * (360 / 12);
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 8,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(22 * 0, -22 * 1),
              child: const Text("12"),
            ),
            for (var i = 1; i < 12; i++)
              Transform.translate(
                offset: Offset(22 * sin(angle * i), -22 * cos(angle * i)),
                child: Text("$i"),
              ),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            const _Pin(),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatefulWidget {
  const _Pin();

  @override
  State<_Pin> createState() => _PinState();
}

class _PinState extends State<_Pin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(period: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hours = now.hour + now.minute / 60;
    final minute = now.minute + now.second / 60;
    final second = now.second + now.millisecond / 1000;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: (pi * 2 / 12) * hours,
          child: FractionalTranslation(
            translation: const Offset(0, -0.5),
            child: Container(
              width: 2.5,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Transform.rotate(
          angle: (pi * 2 / 60) * minute,
          child: FractionalTranslation(
            translation: const Offset(0, -0.5),
            child: Container(
              width: 1.5,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Transform.rotate(
          angle: (pi * 2 / 60) * second,
          child: FractionalTranslation(
            translation: const Offset(0, -0.5),
            child: Container(
              width: 1,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
