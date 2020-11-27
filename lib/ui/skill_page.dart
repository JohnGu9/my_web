import 'package:flutter/material.dart';
import 'package:my_web/ui/home_page.dart';
import 'package:my_web/ui/widgets/delay_show.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homePage = HomePage.of(context);
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
    final borderRadius = cardShape.borderRadius as BorderRadius;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
            left: constraints.maxWidth * homePage.indexSpaceRate,
            top: homePage.padding + homePage.headerMinHeight,
            bottom: homePage.padding,
          ),
          child: Material(
            elevation: homePage.elevation,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: borderRadius.topLeft,
                bottomLeft: borderRadius.bottomLeft,
              ),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: homePage.onPageChanged,
              builder: (context, value, child) {
                return DelayShow(
                  show: value == 1,
                  child: const _Content(),
                  delay: const Duration(milliseconds: 500),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
