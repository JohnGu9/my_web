import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

typedef void _ChangeCurrentWidget(Widget newWidget);

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.controller}) : super(key: key);
  final AnimationController controller;
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpened = false;

  late Widget _currentPage;
  Widget get _mainPage {
    return _MainPage(
      animation: _controller,
      changePage: (Widget newWidget) {
        setState(() {
          _currentPage = newWidget;
        });
      },
    );
  }

  _listener() {
    if (widget.controller.value > 0.75 && _isOpened == false) {
      _isOpened = true;
      _controller.animateTo(1.0);
    } else if (widget.controller.value - widget.controller.lowerBound < 0.01) {
      _isOpened = false;
      _controller.value = 0.0;
      _currentPage = _mainPage;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    widget.controller.addListener(_listener);
    _currentPage = _mainPage;
  }

  @override
  void didUpdateWidget(covariant SettingPage oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_listener);
      widget.controller.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment(-1.0, 0),
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: ListTileTheme(
        shape: const StadiumBorder(),
        child: PageTransitionSwitcher(
          transitionBuilder: (Widget child, Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          reverse: _currentPage is _MainPage,
          child: _currentPage,
        ),
      ),
    );
  }
}

class _MainPage extends StatelessWidget {
  const _MainPage({Key? key, required this.animation, required this.changePage})
      : super(key: key);
  final Animation<double> animation; // init animation
  final _ChangeCurrentWidget changePage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return Material(
      child: CustomScrollView(
        slivers: [
          GroupAnimationService.passiveHost(
            animation: animation,
            child: SliverList(
              delegate: SliverChildListDelegate.fixed([
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      title: Text(
                        locale.settings,
                        style: theme.textTheme.headline4,
                      ),
                    ),
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    leading: const Icon(Icons.brightness_4),
                    title: Text(locale.darkTheme),
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                    onTap: () {},
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    leading: const Icon(Icons.translate),
                    title: Text(locale.language),
                    onTap: () {
                      changePage(_LanguagePage(
                          animation: animation, changePage: changePage));
                    },
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    leading: const Icon(Icons.text_snippet),
                    title: Text(locale.license),
                    onTap: () {
                      changePage(_LicensePage(
                          animation: animation, changePage: changePage));
                    },
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(locale.about),
                    onTap: () {
                      changePage(_AboutPage(
                          animation: animation, changePage: changePage));
                    },
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  static Widget _animationBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween(begin: const Offset(0.05, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

class _LanguagePage extends StatelessWidget {
  const _LanguagePage(
      {Key? key, required this.animation, required this.changePage})
      : super(key: key);
  final Animation<double> animation; // init animation
  final _ChangeCurrentWidget changePage;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate.fixed([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListTile(
              title: Text(
                locale.language,
                style: theme.textTheme.headline4,
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    changePage(_MainPage(
                        animation: animation, changePage: changePage));
                  }),
            ),
          ),
        ])),
      ],
    );
  }
}

class _LicensePage extends StatelessWidget {
  const _LicensePage(
      {Key? key, required this.animation, required this.changePage})
      : super(key: key);
  final Animation<double> animation; // init animation
  final _ChangeCurrentWidget changePage;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate.fixed([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListTile(
              title: Text(
                locale.license,
                style: theme.textTheme.headline4,
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    changePage(_MainPage(
                        animation: animation, changePage: changePage));
                  }),
            ),
          ),
        ])),
      ],
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage(
      {Key? key, required this.animation, required this.changePage})
      : super(key: key);
  final Animation<double> animation; // init animation
  final _ChangeCurrentWidget changePage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate.fixed([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListTile(
              title: Text(
                locale.about,
                style: theme.textTheme.headline4,
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    changePage(_MainPage(
                        animation: animation, changePage: changePage));
                  }),
            ),
          ),
          ListTile(
            title: Text(locale.version),
            trailing: const Text(Constants.buildVersion),
          ),
          ListTile(
            title: const Text("Flutter"),
            trailing: Text(Constants.frameworkVersion),
          ),
          ListTile(
            trailing: Text(Constants.channel),
          ),
          ListTile(
            trailing: Text(Constants.frameworkRevision),
          ),
          ListTile(
            trailing: Text(Constants.frameworkCommitDate),
          ),
          ListTile(
            trailing: Text(Constants.repositoryUrl),
          ),
        ])),
      ],
    );
  }
}
