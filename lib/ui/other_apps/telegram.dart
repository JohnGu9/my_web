import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';

class Telegram extends StatelessWidget {
  const Telegram({super.key});
  static final appData = AppData(
    app: const Telegram(),
    icon: Container(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: const Icon(
        Icons.near_me,
        color: Colors.white,
        size: 42,
      ),
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Telegram',
  );

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      tabBuilder: (context, index) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: TextButton(
                onPressed: () {},
                child: const Text("Edit"),
              ),
              title: () {
                switch (index) {
                  case 0:
                    return const Text("Contacts");
                  case 1:
                    return const Text("Chats");
                  default:
                    return const Text("Setting");
                }
              }(),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
