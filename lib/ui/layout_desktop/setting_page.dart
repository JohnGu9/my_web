import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                const GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: _ThemeListTile(),
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
                    onTap: () async {
                      final license = await rootBundle.loadString('LICENSE');
                      changePage(_LicensePage(
                        animation: animation,
                        changePage: changePage,
                        license: license,
                      ));
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

class _ThemeListTile extends StatelessWidget {
  const _ThemeListTile();
  @override
  Widget build(BuildContext context) {
    final locale = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    final themeService = ThemeService.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ListTile(
      leading: const Icon(Icons.brightness_4),
      title: Text(locale.darkTheme),
      trailing: Switch.adaptive(
        value: theme.brightness == Brightness.dark,
        onChanged: (value) {
          return themeService.changeTheme(
              value ? ThemeService.darkTheme : ThemeService.lightTheme);
        },
      ),
      onTap: isDark
          ? () => themeService.changeTheme(ThemeService.lightTheme)
          : () => themeService.changeTheme(ThemeService.darkTheme),
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
    final localeService = LocaleService.of(context);
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                title: Text(
                  locale.language,
                  style: theme.textTheme.headline4,
                ),
                trailing: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: CircleBorder(
                      side: BorderSide(color: theme.disabledColor, width: 2)),
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        changePage(_MainPage(
                            animation: animation, changePage: changePage));
                      }),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            ListTile(
              selected: localeService.locale == LocaleService.en,
              title: const Text("English"),
              trailing: localeService.locale == LocaleService.en
                  ? const Icon(Icons.check)
                  : const SizedBox(),
              onTap: localeService.locale == LocaleService.en
                  ? null
                  : () async {
                      if (await localeService.loadFont(LocaleService.en))
                        await localeService.changeLocale(LocaleService.en);
                    },
            ),
            ListTile(
              selected: localeService.locale == LocaleService.zh,
              title: const Text("Chinese"),
              trailing: localeService.locale == LocaleService.zh
                  ? const Icon(Icons.check)
                  : const SizedBox(),
              onTap: localeService.locale == LocaleService.zh
                  ? null
                  : () async {
                      if (await localeService.loadFont(LocaleService.zh))
                        await localeService.changeLocale(LocaleService.zh);
                    },
            ),
          ])),
        ],
      ),
    );
  }
}

class _LicensePage extends StatelessWidget {
  const _LicensePage(
      {Key? key,
      required this.animation,
      required this.changePage,
      required this.license})
      : super(key: key);
  final Animation<double> animation; // init animation
  final _ChangeCurrentWidget changePage;
  final String license;
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
              trailing: Material(
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(
                    side: BorderSide(color: theme.disabledColor, width: 2)),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      changePage(_MainPage(
                          animation: animation, changePage: changePage));
                    }),
              ),
            ),
          ),
          ListTile(
            subtitle: Text(license),
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
              trailing: Material(
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(
                    side: BorderSide(color: theme.disabledColor, width: 2)),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      changePage(_MainPage(
                          animation: animation, changePage: changePage));
                    }),
              ),
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
