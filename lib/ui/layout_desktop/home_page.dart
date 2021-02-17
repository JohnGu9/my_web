import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(locale.home),
          ),
        ],
      ),
    );
  }
}
