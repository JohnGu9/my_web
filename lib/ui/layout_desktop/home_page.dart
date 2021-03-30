import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
      ..animateBack(0.0,
          curve: Curves.fastOutSlowIn, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get _settingPage {
    return FractionallySizedBox(
      alignment: Alignment.topRight,
      heightFactor: 0.9,
      widthFactor: 0.7,
      child: SlideTransition(
          position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
              .animate(_controller),
          child: SettingPage(controller: _controller)),
    );
  }

  Widget get _settingsButton {
    return FractionallySizedBox(
      alignment: Alignment.topRight,
      heightFactor: 0.1,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageTransitionSwitcher(
            transitionBuilder: _settingsButtonTransition,
            reverse: !_isOpened,
            child: _isOpened ? _settingsCloseButton : _settingsOpenButton,
          ),
        ),
      ),
    );
  }

  static Widget _settingsButtonTransition(
      Widget child,
      Animation<double> primaryAnimation,
      Animation<double> secondaryAnimation) {
    return SharedAxisTransition(
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      child: child,
    );
  }

  Widget get _settingsOpenButton {
    return Material(
      key: ValueKey(false),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          setState(() {
            _isOpened = true;
            _controller.animateWith(SpringSimulation(
                spring, _controller.value, 1.0, _controller.velocity));
          });
        },
      ),
    );
  }

  Widget get _settingsCloseButton {
    return Material(
      key: ValueKey(true),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _isOpened = false;
            _controller.animateWith(SpringSimulation(
                spring, _controller.value, 0.0, _controller.velocity));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content() {
      return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return FractionallySizedBox(
            alignment: Alignment.bottomRight,
            widthFactor: Tween(begin: 0.9, end: 1.0).evaluate(_controller),
            heightFactor: 0.9,
            child: child,
          );
        },
        child: SlideTransition(
          position: Tween(begin: Offset.zero, end: const Offset(0.0, 8 / 9))
              .animate(_controller),
          child: Material(
            color: theme.primaryColor.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: ((theme.cardTheme.shape as RoundedRectangleBorder)
                          .borderRadius as BorderRadius)
                      .topLeft),
            ),
            child: SlideTransition(
              position: Tween(begin: Offset.zero, end: const Offset(0.0, 0.3))
                  .animate(_controller),
              child: FadeTransition(
                opacity: Tween(begin: 1.0, end: 0.0).animate(_controller),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerRight,
                      widthFactor: Tween(begin: 7 / 9, end: 7 / 10)
                          .evaluate(_controller),
                      child: child,
                    );
                  },
                  child: const _Content(),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget navigator() {
      return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: Tween(begin: 0.4, end: 0.2).evaluate(_controller),
            child: Container(
              color: theme.primaryColor.withOpacity(0.7),
              child: FractionallySizedBox(
                alignment: Alignment.bottomRight,
                widthFactor: Tween(begin: 0.75, end: 1.0).evaluate(_controller),
                heightFactor: 0.9,
                child: child,
              ),
            ),
          );
        },
        child: SlideTransition(
          position: Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0))
              .animate(_controller),
          child: FadeTransition(
            opacity: Tween(begin: 1.0, end: 0.0).animate(_controller),
            child: const _Navigator(),
          ),
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            _settingPage,
            content(),
            navigator(),
            _settingsButton,
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
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: CustomScrollView(
        slivers: [
          const _PageSelectorColumn(),
          SliverFillRemaining(
            fillOverscroll: false,
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _SearchBox(),
                  const _ReferenceRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSelectorColumn extends StatelessWidget {
  const _PageSelectorColumn();
  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTileTheme(
        dense: false,
        textColor: Colors.white,
        child: SliverList(
          delegate: SliverChildListDelegate.fixed([
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Padding(
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
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ListTile(
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
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ListTile(
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
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ListTile(
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
            ),
          ]),
        ),
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = StandardLocalizations.of(context);
    return Row(
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8.0),
          child: Text(locale.help,
              style: textTheme.caption!.copyWith(color: Colors.white60)),
          onPressed: () {},
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8.0),
          child: Text(locale.privacy,
              style: textTheme.caption!.copyWith(color: Colors.white60)),
          onPressed: () {},
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8.0),
          child: Text(locale.terms,
              style: textTheme.caption!.copyWith(color: Colors.white60)),
          onPressed: () {},
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8.0),
          child: Text(locale.more,
              style: textTheme.caption!.copyWith(color: Colors.white60)),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.white30,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: (theme.cardTheme.shape as RoundedRectangleBorder)
                .borderRadius as BorderRadius,
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          hintText: locale.search,
          hintStyle: const TextStyle(color: Colors.white70)),
      textInputAction: TextInputAction.search,
      autofocus: false,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();
  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    final padding = ListTileTheme.of(context).contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.0);
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 6 / 7,
      child: FractionallySizedBox(
        alignment: Alignment(-0.3, 0.0),
        heightFactor: 0.9,
        widthFactor: 0.8,
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: padding,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            locale.profile,
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        subtitle: Text(
                          locale.personDescription,
                          style: theme.textTheme.caption,
                        ),
                      ),
                    ),
                    const Image(image: Constants.personLogoImage, width: 100)
                  ],
                ),
              ),
              Padding(
                padding: padding,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Image(
                          image: Constants.githubLogoImage,
                          width: 20,
                        ),
                        label: const Text("Github")),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Image(
                        image: Constants.mediumLogoImage,
                        width: 20,
                      ),
                      label: Text('View article'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: padding,
                child: const _CardRow(),
              )
            ]))
          ],
        ),
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow();

  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 32 * 2),
          child: Material(
            elevation: 1,
            shape: theme.cardTheme.shape,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Image(
                  image: Constants.backgroundImage,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListTile(
                    title: Text(
                      locale.backgroundDescription,
                      style: theme.textTheme.caption,
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
        const SizedBox(width: 16),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Material(
            elevation: 1,
            shape: theme.cardTheme.shape,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Image(
                  image: Constants.skillImage,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListTile(
                    title: Text(
                      locale.backgroundDescription,
                      style: theme.textTheme.caption,
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
        const SizedBox(width: 16),
        Expanded(
            child: Material(
          elevation: 1,
          shape: theme.cardTheme.shape,
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Image(
                image: Constants.otherImage,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListTile(
                  title: Text(
                    locale.backgroundDescription,
                    style: theme.textTheme.caption,
                  ),
                ),
              )
            ],
          ),
        )),
      ],
    );
  }
}
