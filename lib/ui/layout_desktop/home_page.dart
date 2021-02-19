import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_web/core/core.dart';
import 'package:my_web/ui/layout_desktop/setting_page.dart';
import 'package:animations/animations.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  late AnimationController _controller;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1)
      ..animateBack(
        0.0,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery.removePadding(
      context: context,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topRight,
              heightFactor: 0.9,
              widthFactor: 0.7,
              child: SlideTransition(
                  position:
                      Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
                          .animate(_controller),
                  child: SettingPage(controller: _controller)),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return FractionallySizedBox(
                  alignment: Alignment.bottomRight,
                  widthFactor:
                      Tween(begin: 0.9, end: 1.0).evaluate(_controller),
                  heightFactor: 0.9,
                  child: child,
                );
              },
              child: SlideTransition(
                position:
                    Tween(begin: Offset.zero, end: const Offset(0.0, 8 / 9))
                        .animate(_controller),
                child: Material(
                  color: theme.primaryColor.withOpacity(0.25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft:
                              ((theme.cardTheme.shape as RoundedRectangleBorder)
                                      .borderRadius as BorderRadius)
                                  .topLeft)),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      Tween(begin: 0.4, end: 0.2).evaluate(_controller),
                  child: Container(
                    color: theme.primaryColor.withOpacity(0.7),
                    child: FractionallySizedBox(
                      alignment: Alignment.bottomRight,
                      widthFactor:
                          Tween(begin: 0.75, end: 1.0).evaluate(_controller),
                      heightFactor: 0.9,
                      child: child,
                    ),
                  ),
                );
              },
              child: SlideTransition(
                position:
                    Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0))
                        .animate(_controller),
                child: FadeTransition(
                  opacity: Tween(begin: 1.0, end: 0.0).animate(_controller),
                  child: const _Navigator(),
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              heightFactor: 0.1,
              child: Align(
                alignment: Alignment.centerRight,
                child: PageTransitionSwitcher(
                  reverse: !_isOpened,
                  transitionBuilder: (Widget child,
                      Animation<double> primaryAnimation,
                      Animation<double> secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: _isOpened
                      ? Material(
                          key: ValueKey(true),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isOpened = false;
                                _controller.animateWith(SpringSimulation(
                                    spring,
                                    _controller.value,
                                    0.0,
                                    _controller.velocity));
                              });
                            },
                          ),
                        )
                      : Material(
                          key: ValueKey(false),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              setState(() {
                                _isOpened = true;
                                _controller.animateWith(SpringSimulation(
                                    spring,
                                    _controller.value,
                                    1.0,
                                    _controller.velocity));
                              });
                            },
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Navigator extends StatelessWidget {
  const _Navigator();

  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        widthFactor: 0.9,
        child: CustomScrollView(
          slivers: [
            ListTileTheme(
              dense: false,
              textColor: Colors.white,
              child: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      title: Text(
                        locale.home,
                        style: TextStyle(
                          fontSize: textTheme.headline4!.fontSize,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                        Text(
                          locale.background,
                          style: TextStyle(
                            fontSize: textTheme.headline6!.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                        Text(
                          locale.skill,
                          style: TextStyle(
                            fontSize: textTheme.headline6!.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                        Text(
                          locale.other,
                          style: TextStyle(
                            fontSize: textTheme.headline6!.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
