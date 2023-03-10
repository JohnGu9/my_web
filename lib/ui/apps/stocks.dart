import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Stocks extends StatelessWidget {
  static final appData = AppData(
    app: const Stocks(),
    icon: const Icon(
      Icons.trending_up,
      color: Colors.white,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Stocks',
  );

  const Stocks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.trending_up);
  }
}
