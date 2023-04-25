import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class Books extends StatelessWidget {
  const Books({super.key});
  static final appData = AppData(
    app: const Books(),
    icon: const Icon(
      Icons.import_contacts,
      color: Colors.white,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.orange,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Books',
  );

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.import_contacts),
          label: 'Reading Now',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      tabBuilder: StandardAppLayout.onlyAppBar(const [
        Text('Reading Now'),
        Text('Library'),
        Text('Search'),
      ], [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
        ),
      ]),
    );
  }
}
