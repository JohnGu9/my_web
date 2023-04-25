import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});
  static final appData = AppData(
    app: const Wallet(),
    icon: Icon(
      Icons.wallet,
      color: Colors.grey.shade300,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Wallet',
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Wallet"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.category),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 5 / 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
