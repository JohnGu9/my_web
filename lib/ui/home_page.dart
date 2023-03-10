import 'package:flutter/material.dart';

import 'home_page/desktop_view.dart';
import 'home_page/notification_bar.dart';
import 'home_page/task_manager_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(
          top: NotificationBar.statusBarHeight,
          bottom: 28,
        )),
        child: LayoutBuilder(builder: (context, constraints) {
          final data = MediaQuery.of(context);
          return NotificationBar(
            constraints: constraints,
            child: TaskManagerView(
              constraints: constraints,
              child: MediaQuery(
                data: data.copyWith(
                  padding: const EdgeInsets.only(
                    top: NotificationBar.statusBarHeight,
                    bottom: 28,
                  ),
                ),
                child: DesktopView(
                  constraints: constraints,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
