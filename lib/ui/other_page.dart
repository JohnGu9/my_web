import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/ui/widgets/animated_ink_well.dart';
import 'package:my_web/ui/widgets/context_menu.dart';

import 'home_page.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({Key key}) : super(key: key);
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
            clipBehavior: Clip.hardEdge,
            elevation: homePage.elevation,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: borderRadius.topLeft,
                bottomLeft: borderRadius.bottomLeft,
              ),
            ),
            child: HomePage.scrollBarrier(page: 3, child: const _Content()),
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
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GroupAnimationService.passiveHost(
      animation: _controller,
      child: Row(
        children: [
          const Expanded(
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _MyHobbies(),
            ),
          ),
          const Expanded(
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _MyExpectation(),
            ),
          ),
          Expanded(
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _More(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _animatedItemBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    return GroupAnimationService.passiveHost(
      animation: animation,
      child: ScaleTransition(
        scale: Tween(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}

class _MyHobbies extends StatelessWidget {
  const _MyHobbies({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return AnimatedInkWell(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(localization.myHobbies),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          Expanded(
            child: ListView(
              children: [
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: ContextMenu(
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(title: Text(localization.game)),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: const [
                                  Chip(label: Text('GTA5')),
                                  Chip(label: Text('The Division')),
                                  Chip(label: Text('BattleFelid 1')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: ContextMenu(
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(localization.electronicProduction),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: const [
                                  Chip(label: Text('Computer')),
                                  Chip(label: Text('Phone')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MyExpectation extends StatelessWidget {
  const _MyExpectation({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return AnimatedInkWell(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(localization.myExpectation),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          Expanded(
            child: ListView(
              children: [
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: ContextMenu(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(localization.myExpectationDescription),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _More extends StatelessWidget {
  const _More({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return AnimatedInkWell(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(localization.more),
          ),
          Expanded(
            child: ListView(
              children: [
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: Card(
                    child: ListTile(
                      title: const Text('1996'),
                      trailing: const Icon(Icons.calendar_today),
                      subtitle: Text(localization.born),
                    ),
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: Card(
                    child: ListTile(
                      title: const Text('Visual Studio Code'),
                      trailing: const Icon(Icons.developer_mode),
                      subtitle: Text('${localization.favorite} IDE'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _animatedItemBuilder(
    BuildContext context, Animation<double> animation, Widget child) {
  final curvedAnimation =
      CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
  return SlideTransition(
    position: Tween(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(curvedAnimation),
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
