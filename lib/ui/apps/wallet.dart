import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Wallet extends StatelessWidget {
  static final appData = AppData(
    app: const Wallet(),
    icon: Icon(
      Icons.wallet,
      color: Colors.grey.shade300,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Wallet',
  );

  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.wallet);
  }
}