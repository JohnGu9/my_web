import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class Photos extends StatelessWidget {
  const Photos({super.key});
  static final appData = AppData(
    app: const Photos(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Photos',
  );

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.photo),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.rectangle),
          label: 'For You',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.square_stack),
          label: 'Albums',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          label: 'Search',
        ),
      ],
      tabBuilder: (context, index) {
        return const Center();
      },
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        _Card(color: Colors.orange, angle: 0),
        _Card(color: Colors.yellow, angle: pi / 4 * 1),
        _Card(color: Colors.lightGreen, angle: pi / 4 * 2),
        _Card(color: Colors.green, angle: pi / 4 * 3),
        _Card(color: Colors.blue, angle: pi / 4 * 4),
        _Card(color: Colors.purple, angle: pi / 4 * 5),
        _Card(color: Colors.pink, angle: pi / 4 * 6),
        _Card(color: Colors.red, angle: pi / 4 * 7),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.color, required this.angle});
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: FractionalTranslation(
        translation: const Offset(0.55, 0),
        child: Container(
          height: 18,
          width: 26,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
        ),
      ),
    );
  }
}
