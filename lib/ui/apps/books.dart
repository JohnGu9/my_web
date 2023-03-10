import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Books extends StatelessWidget {
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

  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.import_contacts);
  }
}