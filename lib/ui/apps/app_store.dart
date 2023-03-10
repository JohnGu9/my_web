import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class AppStore extends StatelessWidget {
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

  const AppStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
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
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar.medium(
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
