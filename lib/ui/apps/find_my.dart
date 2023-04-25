import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/standard_app.dart';
import 'package:my_web/ui/widgets/web_view.dart';

class FindMy extends StatelessWidget {
  const FindMy({super.key});
  static final appData = AppData(
    app: const FindMy(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.grey.shade300,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Find My',
  );

  @override
  Widget build(BuildContext context) {
    return StandardAppLayout(
      tabBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'People',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.devices),
          label: 'Devices',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
      tabBuilder: (context, index) {
        return WebView(uri: Uri.parse("https://www.google.com/maps/"));
      },
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
