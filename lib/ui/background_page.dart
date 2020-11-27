import 'package:flutter/material.dart';
import 'package:my_web/core/services/locale_service.dart';

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
                return value == 1
                    ? const _Content(show: true)
                    : const _Content(show: false);
              },
            ),
          ),
        );
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key key, this.show}) : super(key: key);
  final bool show;

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content>
    with SingleTickerProviderStateMixin<_Content> {
  AnimationController _controller;
  Widget child = const SizedBox();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _delayShow();
  }

  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    if (widget.show && widget.show) _delayShow();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _delayShow() {
    Future.delayed(const Duration(milliseconds: 350), () async {
      if (mounted && widget.show)
        setState(() {
          child = _Cards(animation: _controller);
          _controller.animateTo(1.0, duration: const Duration(seconds: 1));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return child;
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
