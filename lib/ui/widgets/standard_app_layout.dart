import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandardAppLayout extends StatelessWidget {
  const StandardAppLayout(
      {super.key, required this.tabBarItems, required this.tabBuilder});

  static Widget Function(BuildContext context, int index) onlyAppBar(
      List<Widget> titles,
      [List<Widget>? actions]) {
    return (BuildContext context, int index) {
      return CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            pinned: true,
            title: titles[index],
            actions: actions,
          )
        ],
      );
    };
  }

  final List<BottomNavigationBarItem> tabBarItems;
  final Widget Function(BuildContext context, int index) tabBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: tabBarItems,
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return tabBuilder(context, index);
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
