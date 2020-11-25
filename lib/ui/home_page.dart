import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '.lib.dart';
import 'package:my_web/core/.lib.dart';

class HomePage extends StatefulWidget {
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
    return Stack(
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
              child: _RouteBarrier(shouldBarrier: isOpened, child: child),
            );
          },
          child: Stack(
            children: [
              const _ScrollView(),
              Align(
                alignment: Alignment.topRight,
                child: FadeTransition(
                  opacity: Tween(begin: 1.0, end: 0.0).animate(_controller),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: ButtonBar(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: open,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScrollView extends StatefulWidget {
  static _ScrollViewInheritedWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScrollViewInheritedWidget>();
  }

  const _ScrollView({Key key}) : super(key: key);

  @override
  __ScrollViewState createState() => __ScrollViewState();
}

class __ScrollViewState extends State<_ScrollView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      child: _ScrollViewInheritedWidget(
        state: this,
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          children: const <Widget>[
            const _Content(),
            const BackgroundPage(),
            const SkillPage(),
            const OtherPage(),
          ],
        ),
      ),
    );
  }
}

class _ScrollViewInheritedWidget extends InheritedWidget {
  const _ScrollViewInheritedWidget({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final __ScrollViewState state;

  scrollTo(int page) {
    return state._pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  bool updateShouldNotify(covariant _ScrollViewInheritedWidget oldWidget) {
    return state != oldWidget.state;
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

  Animation<double> get _mainIndexAnimation {
    return CurvedAnimation(
      curve: const Interval(0.6, 1),
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
    final spring = SpringProvideService.of(context);
    return ScopeNavigator(
      spring: spring,
      child: CustomScrollView(
        slivers: [
          SliverPinnedHeader(
            child: Material(
              color: theme.canvasColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 72),
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
            ),
          ),
          SliverToBoxAdapter(
            child: _MainIndex(animation: _mainIndexAnimation),
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
    return Tooltip(
      message: StandardLocalizations.of(context).visit,
      child: DetailButton(
        simple: const Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Image(
            image: Constants.githubLogoImage,
            height: 32,
          ),
        ),
        detail: const Text(_url),
        onTap: () {
          return showVisitWebsiteDialog(context, _url);
        },
      ),
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
            image: Constants.mailLogoImage,
            height: 32,
          ),
        ),
        detail: const SelectableText(_address),
        onTap: () {
          return Clipboard.setData(const ClipboardData(text: _address));
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

class _MainIndex extends StatelessWidget {
  const _MainIndex({Key key, this.animation}) : super(key: key);
  final Animation<double> animation;

  Animation<double> get _animation0 {
    return CurvedAnimation(
        curve: Interval(0, 0.7, curve: Curves.fastOutSlowIn),
        parent: animation);
  }

  Animation<double> get _animation1 {
    return CurvedAnimation(
        curve: Interval(0.2, 0.9, curve: Curves.fastOutSlowIn),
        parent: animation);
  }

  Animation<double> get _animation2 {
    return CurvedAnimation(
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn),
        parent: animation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween = ColorTween(
      begin: theme.primaryColor.withOpacity(0.0),
      end: theme.primaryColor,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(72.0),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
                shape: theme.cardTheme.shape,
                color: colorTween.evaluate(animation),
                child: child);
          },
          child: SizedBox(
            height: 250,
            child: IconTheme(
              data: theme.iconTheme
                  .copyWith(color: Colors.white70.withOpacity(0.8)),
              child: Row(
                children: [
                  _itemBuilder(
                      theme,
                      _animation0,
                      const Icon(Icons.assignment_ind, size: 72),
                      StandardLocalizations.of(context).background, () {
                    _ScrollView.of(context).scrollTo(1);
                  }),
                  VerticalDivider(),
                  _itemBuilder(
                      theme,
                      _animation1,
                      const Icon(Icons.build, size: 72),
                      StandardLocalizations.of(context).skill, () {
                    _ScrollView.of(context).scrollTo(2);
                  }),
                  VerticalDivider(),
                  _itemBuilder(
                      theme,
                      _animation2,
                      const Icon(Icons.scatter_plot, size: 72),
                      StandardLocalizations.of(context).other, () {
                    _ScrollView.of(context).scrollTo(3);
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static final _offsetTween =
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0));

  Widget _itemBuilder(ThemeData theme, Animation<double> animation, Widget icon,
      String title, Function() onTap) {
    return Expanded(
      child: SlideTransition(
        position: _offsetTween.animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              shape: theme.cardTheme.shape,
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: AnimatedInkWell(
                onTap: onTap,
                builder: (context, animation, child) {
                  return child;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(16.0), child: icon),
                    Text(title,
                        style: theme.textTheme.headline3
                            .copyWith(color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
