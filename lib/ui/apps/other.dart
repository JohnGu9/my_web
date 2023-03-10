import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Other extends StatelessWidget {
  static final appData = AppData(
    app: const Other(),
    icon: const Icon(
      Icons.android,
      color: Colors.black,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'adb',
  );

  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.android);
  }
}
