import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/localizations_delegates.dart';

class StandardApp extends StatelessWidget {
  const StandardApp({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollBehavior = ScrollConfiguration.of(context);
    final locale = Localizations.localeOf(context);
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      theme: theme,
      locale: locale,
      scrollBehavior: scrollBehavior,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      home: MediaQuery(
        data: mediaQuery,
        child: child,
      ),
    );
  }
}

class StandardAppLayout extends StatelessWidget {
  const StandardAppLayout(
      {super.key, required this.tabBarItems, required this.tabBuilder});

  static Widget Function(BuildContext context, int index) onlyAppBar(
      List<Widget> titles,
      [List<Widget>? actions]) {
    return (BuildContext context, int index) {
      return CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            title: titles[index],
            actions: actions,
          ),
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
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return tabBuilder(context, index);
                },
              );
            },
            tabBar: CupertinoTabBar(
              items: tabBarItems,
            ),
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
