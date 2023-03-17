import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Reminders extends StatelessWidget {

  const Reminders({super.key});
  static final appData = AppData(
    app: const Reminders(),
    icon: const Icon(
      Icons.list,
      color: Colors.grey,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Reminders',
  );

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.list);
  }
}
