import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class About extends StatelessWidget {
  const About({super.key});

  static final appData = AppData(
    app: const About(),
    icon: const FlutterLogo(),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: "About",
  );

  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: "My Web",
      applicationIcon: Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(),
      ),
      applicationVersion: "@JohnGu9",
    );
  }
}
