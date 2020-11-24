import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '.lib.dart';
import 'package:my_web/core/.lib.dart';

class HomePage extends StatefulWidget {
  static _HomePage of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HomePage>();
  }

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin<HomePage>,
        RouteControllerMixin<HomePage> {
  static const _settingsPageWidth = 400.0;
  AnimationController _controller;

  @override
  AnimationController get controller => _controller;

  @override
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  SpringDescription get spring => SpringProvideService.of(context);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener(routeListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _HomePage(
      state: this,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Focus(
            focusNode: focusScopeNode,
            child: Material(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizeTransition(
                  axis: Axis.horizontal,
                  sizeFactor: _controller,
                  child: const SizedBox(
                    width: _settingsPageWidth,
                    child: SettingsPage(),
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(-_settingsPageWidth * _controller.value, 0),
                child: _RouteBarrier(
                  shouldBarrier: isOpened,
                  child: child,
                ),
              );
            },
            child: _Content(animation: _controller),
          ),
        ],
      ),
    );
  }
}

class _HomePage extends InheritedWidget {
  const _HomePage({Key key, Widget child, this.state})
      : super(key: key, child: child);

  @visibleForTesting
  final _HomePageState state;

  pushSettingsPage() {
    return state.open();
  }

  @override
  bool updateShouldNotify(covariant _HomePage oldWidget) {
    return oldWidget.state != state;
  }
}

class _Content extends StatefulWidget {
  const _Content({Key key, this.animation}) : super(key: key);
  final Animation<double> animation;

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content>
    with SingleTickerProviderStateMixin<_Content> {
  AnimationController _controller;

  Animation<double> get _personLogoAnimation {
    return CurvedAnimation(
      curve: const Interval(0.1, 0.4, curve: Curves.fastOutSlowIn),
      parent: _controller,
    );
  }

  Animation<double> get _titleAnimation {
    return CurvedAnimation(
      curve: const Interval(0.35, 0.7, curve: Curves.fastOutSlowIn),
      parent: _controller,
    );
  }

  Animation<double> get _linksSizeAnimation {
    return CurvedAnimation(
      curve: const Interval(0.6, 0.75, curve: Curves.fastOutSlowIn),
      parent: _controller,
    );
  }

  Animation<double> get _linksOpacityAnimation {
    return CurvedAnimation(
      curve: const Interval(0.7, 0.85, curve: Curves.fastOutSlowIn),
      parent: _controller,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future.delayed(const Duration(milliseconds: 25), () async {
      if (mounted) {
        _controller.animateTo(1.0, duration: const Duration(seconds: 3));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 16.0,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            textTheme: theme.textTheme,
            iconTheme: theme.iconTheme,
            actions: [
              IconButton(
                onPressed: HomePage.of(context).pushSettingsPage,
                icon: FadeTransition(
                  opacity: Tween(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(widget.animation),
                  child: const Icon(Icons.settings),
                ),
              ),
            ],
          ),
          SliverPinnedHeader(
            child: SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _personLogoAnimation,
                    alignment: Alignment.center,
                    child: const _Logo(),
                  ),
                  const SizedBox(width: 48),
                  SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: _titleAnimation,
                    child: FadeTransition(
                      opacity: _titleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              StandardLocalizations.of(context).profile,
                              style: theme.textTheme.headline1,
                            ),
                          ),
                          SizeTransition(
                            sizeFactor: _linksSizeAnimation,
                            child: FadeTransition(
                              opacity: _linksOpacityAnimation,
                              child: Row(
                                children: const [
                                  const _GithubButton(),
                                  const SizedBox(width: 8),
                                  const _MailButton(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GithubButton extends StatelessWidget {
  static const _url = 'https://github.com/JohnGu9';

  const _GithubButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DetailButton(
      simple: const Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Image(
          image: Constants.githubLogoImage,
          height: 32,
        ),
      ),
      detail: const Text(_url),
      onTap: () async {
        if (await canLaunch(_url)) launch(_url);
      },
    );
  }
}

class _MailButton extends StatelessWidget {
  static const _address = 'johngustyle@outlook.com';
  const _MailButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: StandardLocalizations.of(context).copy,
      child: DetailButton(
        simple: const Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Image(
            image: Constants.gmailLogoImage,
            height: 32,
          ),
        ),
        detail: const SelectableText(_address),
        onTap: () {
          return Clipboard.setData(ClipboardData(text: _address));
        },
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  const _Logo({Key key}) : super(key: key);

  @override
  __LogoState createState() => __LogoState();
}

class __LogoState extends State<_Logo>
    with SingleTickerProviderStateMixin<_Logo> {
  AnimationController _controller;

  SpringDescription get _spring {
    return SpringProvideService.of(context);
  }

  Animation<double> get _scale {
    return Tween(begin: 1.0, end: 0.9).animate(_controller);
  }

  Animation<double> _borderSideWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _borderSideWidth = Tween(begin: 6.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onHover(bool value) {
    if (!mounted) return;
    _controller.animateWith(SpringSimulation(
      _spring,
      _controller.value,
      value ? 1.0 : 0.0,
      _controller.velocity,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      alignment: Alignment.center,
      scale: _scale,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _borderSideWidth,
          builder: (context, child) {
            return Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration.zero,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                side: BorderSide(
                  color: theme.accentColor,
                  width: _borderSideWidth.value,
                ),
              ),
              child: child,
            );
          },
          child: Ink.image(
            image: Constants.personLogoImage,
            child: InkWell(
              onTap: () {},
              onHover: _onHover,
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteBarrier extends StatelessWidget {
  const _RouteBarrier({
    Key key,
    this.child,
    this.shouldBarrier,
  }) : super(key: key);

  final Widget child;
  final bool shouldBarrier;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: shouldBarrier,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        foregroundDecoration: BoxDecoration(
          color: shouldBarrier ? Colors.black38 : Colors.transparent,
        ),
        child: child,
      ),
    );
  }
}
