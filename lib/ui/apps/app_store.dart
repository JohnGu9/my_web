import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class AppStore extends StatelessWidget {
  const AppStore({super.key});
  static final appData = AppData(
    app: const AppStore(),
    icon: const Icon(
      Icons.change_history,
      color: Colors.white,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.blue,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'App Store',
  );

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rocket_launch),
          label: 'Games',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.reorder),
          label: 'Apps',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      tabBuilder: (context, index) {
        return CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              title: () {
                switch (index) {
                  case 0:
                    return const Text("Today");
                  case 1:
                    return const Text("Games");
                  case 2:
                    return const Text("Apps");
                  default:
                    return const Text("Search");
                }
              }(),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
