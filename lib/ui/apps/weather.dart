import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Weather extends StatelessWidget {

  const Weather({super.key});
  static final appData = AppData(
    app: const Weather(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.blue,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Weather',
  );

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.sunny);
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 8,
          right: 4,
          width: 24,
          height: 24,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
            ),
          ),
        ),
        const Positioned(
            left: 4,
            right: 12,
            top: 6,
            child: Icon(
              Icons.cloud,
              size: 42,
              color: Colors.white70,
            )),
      ],
    );
  }
}
