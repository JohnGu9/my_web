import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class Home extends StatelessWidget {
  const Home({super.key});
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

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.alarm_fill),
          label: 'Automation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Discover',
        ),
      ],
      tabBuilder: (context, index) {
        return const Center();
      },
    );
  }
}
