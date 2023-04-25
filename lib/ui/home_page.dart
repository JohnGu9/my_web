import 'package:flutter/material.dart';
import 'package:my_web/ui/home_page/quick_access.dart';

import 'home_page/desktop_background.dart';
import 'home_page/desktop_view.dart';
import 'home_page/lock_view.dart';
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
        child: LockView(
          child: DesktopBackground(
            child: LayoutBuilder(builder: (context, constraints) {
              return QuickAccess(
                constraints: constraints,
                child: NotificationBar(
                  constraints: constraints,
                  child: TaskManagerView(
                    constraints: constraints,
                    child: DesktopView(
                      constraints: constraints,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
