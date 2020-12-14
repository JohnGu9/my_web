import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/ui/widgets/context_menu.dart';
import 'package:my_web/ui/widgets/rive_board.dart';
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
      child: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(32.0),
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _MyHobbies(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _MyExpectation(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: GroupAnimationService.client(
              builder: _animatedItemBuilder,
              child: _More(),
            ),
          ),
          const SizedBox(height: 72),
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
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 640,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: Text(localization.myHobbies),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    textTheme: theme.textTheme),
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _Effect(
                    child: ContextMenu(
                      child: Card(
                        elevation: 0.0,
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
                ),
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _Effect(
                    child: ContextMenu(
                      child: Card(
                        elevation: 0.0,
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
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: const SizedBox(
            height: 360,
            child: RiveBoard(path: 'assets/riv/hobbies.riv'),
          ),
        ),
      ],
    );
  }
}

class _MyExpectation extends StatelessWidget {
  const _MyExpectation({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        const Expanded(
          child: SizedBox(
            height: 240,
            child: RiveBoard(path: 'assets/riv/mail.riv'),
          ),
        ),
        SizedBox(
          width: 640,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: Text(localization.myExpectation),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    textTheme: theme.textTheme),
                GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _Effect(
                    child: ContextMenu(
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(localization.myExpectationDescription),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _More extends StatelessWidget {
  const _More({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 640,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: Text(localization.more),
                textTheme: theme.textTheme,
              ),
              GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _Effect(
                  child: Card(
                    elevation: 0.0,
                    child: ListTile(
                      title: const Text('1996'),
                      trailing: const Icon(Icons.calendar_today),
                      subtitle: Text(localization.born),
                    ),
                  ),
                ),
              ),
              GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _Effect(
                  child: Card(
                    elevation: 0.0,
                    child: ListTile(
                      title: const Text('Visual Studio Code'),
                      trailing: const Icon(Icons.developer_mode),
                      subtitle: Text('${localization.favorite} IDE'),
                    ),
                  ),
                ),
              ),
              GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _Effect(
                  child: Card(
                    elevation: 0.0,
                    child: ListTile(
                      title: const Text('English'),
                      trailing: const Chip(
                        label: Text('CET 4'),
                      ),
                    ),
                  ),
                ),
              ),
              GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _Effect(
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(localization.attention),
                        subtitle: Text(localization.attentionDescription),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

class _Effect extends StatefulWidget {
  const _Effect({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  __EffectState createState() => __EffectState();
}

class __EffectState extends State<_Effect> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onTap() {}

  _onHover(bool value) {
    _controller.animateTo(
      value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: _onTap,
      onHover: _onHover,
      hoverColor: Colors.transparent,
      child: FadeTransition(
        opacity: Tween(begin: 0.5, end: 1.0).animate(_controller),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: theme.accentColor,
                child: const SizedBox(
                  width: 6,
                  height: 64,
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Tween(
                        begin: Offset.zero,
                        end: const Offset(16, 0),
                      ).evaluate(_curvedAnimation),
                      child: child,
                    );
                  },
                  child: widget.child),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}
