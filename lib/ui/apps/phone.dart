import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class Phone extends StatelessWidget {
  const Phone({super.key});
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

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
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
      tabBuilder: (context, index) {
        return const Center();
      },
    );
  }
}
