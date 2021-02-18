import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return Scaffold(
      body: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            // print('Scrolled');
          }
        },
        child: Stack(
          children: [
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.3,
              child: Container(
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
