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
    final theme = Theme.of(context);
    return Material(
      color: Colors.blueAccent,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64),
                      child: Column(
                        children: [
                          Text(
                            "Somewhere",
                            style: theme.textTheme.headlineMedium,
                          ),
                          Text(
                            "26℃",
                            style: theme.textTheme.displayLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      height: 108,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      height: 108,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.map),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.reorder),
                )
              ],
            ),
          )
        ],
      ),
    );
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
          ),
        ),
      ],
    );
  }
}
