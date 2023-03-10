import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Home extends StatelessWidget {
  static final appData = AppData(
    app: const Home(),
    icon: const Icon(
      Icons.house,
      color: Colors.orange,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Home',
  );

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.house);
  }
}
