import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Stocks extends StatelessWidget {
  const Stocks({super.key});
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Stocks"),
          ),
        ],
      ),
    );
  }
}
