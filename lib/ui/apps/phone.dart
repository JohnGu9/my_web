import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Phone extends StatelessWidget {
  static final appData = AppData(
    app: const Phone(),
    icon: const Icon(
      Icons.phone,
      color: Colors.white,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.green,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Phone',
  );

  const Phone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.star_fill),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.clock_solid),
                  label: 'Recent',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_alt_circle_fill),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
                  label: 'Keypad',
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return const Center();
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
