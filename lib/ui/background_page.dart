import 'package:flutter/material.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/ui/widgets/delay_show.dart';

import 'home_page.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key key}) : super(key: key);
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
              bottom: homePage.padding),
          child: Material(
            elevation: homePage.elevation,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  bottomLeft: borderRadius.bottomLeft),
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

class _Content extends StatefulWidget {
  const _Content({Key key}) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content>
    with SingleTickerProviderStateMixin<_Content> {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Cards(animation: _controller);
  }
}

class _Cards extends StatelessWidget {
  const _Cards({Key key, this.animation}) : super(key: key);
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final textStyle =
        Theme.of(context).textTheme.headline3.copyWith(color: Colors.white);
    return FadeTransition(
      opacity: animation,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                localization.education,
                style: textStyle,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                localization.experiment,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
