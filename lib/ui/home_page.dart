import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/native/native_channel.dart';

import '.lib.dart';
import 'package:my_web/core/.lib.dart';

class HomePage extends StatefulWidget {
  static _HomePage of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HomePage>();
  }

  static Widget scrollBarrier({Key key, int page, Widget child}) {
    return _ScrollBarrier(
      key: key,
      page: page,
      child: child,
    );
  }

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        TickerProviderStateMixin<HomePage>,
        RouteControllerMixin<HomePage>,
        SpringProvideStateMixin {
  static const _settingsPageWidth = 400.0;
  AnimationController _controller;
  AnimationController _heroController;

  PageController _pageController;
  ValueNotifier<int> _currentPage;

  @override
  AnimationController get controller => _controller;

  @override
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  SpringDescription get spring => SpringProvideService.of(context);

  bool get _lock {
    return _pageController.position.isScrollingNotifier.value;
  }

  _scrollTo(int page) async {
    if (!mounted) return;
    if (_currentPage.value == 0) return _pageController.jumpToPage(page);
    _currentPage.value = page;
    await _pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 650),
    );
    _currentPage.value = _pageController.page.round();
  }

  _updatePage(int page) {
    if (_lock) return;
    _currentPage.value = page;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener(routeListener);
    _heroController = AnimationController(vsync: this);
    _pageController = PageController();
    _currentPage = ValueNotifier(0)
      ..addListener(() {
        _heroController.animateWith(SpringSimulation(
            spring,
            _heroController.value,
            _currentPage.value == 0 ? 0.0 : 1.0,
            _heroController.velocity));
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
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
        LayoutBuilder(
          builder: (context, constraints) {
            return SlideTransition(
              position: Tween(
                begin: Offset.zero,
                end: Offset(-(_settingsPageWidth / constraints.maxWidth), 0),
              ).animate(_controller),
              child: ValueListenableBuilder<bool>(
                valueListenable: onRouteChanged,
                builder: _barrierBuilder,
                child: ScopeNavigator(
                  spring: SpringProvideService.of(context),
                  child: Material(
                    elevation: 16.0,
                    child: RepaintBoundary(
                      child: _HomePage(
                        state: this,
                        child: Stack(
                          children: [
                            RepaintBoundary(
                              child: PageView(
                                scrollDirection: Axis.vertical,
                                controller: _pageController,
                                onPageChanged: _updatePage,
                                children: const [
                                  const SizedBox(),
                                  const BackgroundPage(),
                                  const SkillPage(),
                                  const OtherPage(),
                                ],
                              ),
                            ),
                            const _FloatIndex(),
                            const _Header(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget _barrierBuilder(
      BuildContext context, bool value, Widget child) {
    return _RouteBarrier(
      shouldBarrier: value,
      child: child,
    );
  }
}

class _HomePage extends InheritedWidget {
  const _HomePage({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final _HomePageState state;

  Animation<double> get animation {
    return state._controller;
  }

  Animation<double> get heroAnimation {
    return state._heroController;
  }

  scrollTo(int page) {
    return state._scrollTo(page);
  }

  ValueListenable<int> get onPageChanged {
    return state._currentPage;
  }

  ValueListenable<bool> get isScrollingNotifier {
    return state._pageController.position.isScrollingNotifier;
  }

  open() {
    return state.open();
  }

  double get padding {
    return 16;
  }

  double get indexSpaceRate {
    return 1.0 / 5.0;
  }

  double get headerMinHeight {
    return 72.0;
  }

  double get elevation {
    return 4.0;
  }

  @override
  bool updateShouldNotify(covariant _HomePage oldWidget) {
    return state != oldWidget.state;
  }
}

final _headerAlignmentTween =
    Tween<Alignment>(begin: Alignment.center, end: Alignment(-0.9, 0));

class _Header extends StatefulWidget {
  const _Header({Key key}) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _introController;

  Animation<double> get _personLogoAnimation {
    return CurvedAnimation(
      curve: const Interval(0.1, 0.4, curve: Curves.fastOutSlowIn),
      parent: _introController,
    );
  }

  Animation<double> get _titleAnimation {
    return CurvedAnimation(
      curve: const Interval(0.35, 0.7, curve: Curves.fastOutSlowIn),
      parent: _introController,
    );
  }

  Animation<double> get _linksSizeAnimation {
    return CurvedAnimation(
      curve: const Interval(0.6, 0.75, curve: Curves.fastOutSlowIn),
      parent: _introController,
    );
  }

  Animation<double> get _linksOpacityAnimation {
    return CurvedAnimation(
      curve: const Interval(0.7, 0.85, curve: Curves.fastOutSlowIn),
      parent: _introController,
    );
  }

  Animation<double> _titleSize;
  Animation<double> _titleOpacity;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(vsync: this);

    Future.delayed(const Duration(milliseconds: 25), () async {
      if (mounted) {
        _introController.animateTo(1.0, duration: const Duration(seconds: 3));
      }
    });
  }

  @override
  void didChangeDependencies() {
    final homePage = HomePage.of(context);
    _titleSize = Tween(begin: 1.0, end: 0.0).animate(homePage.heroAnimation);
    _titleOpacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: homePage.heroAnimation,
      curve: const Interval(0.0, 0.3),
    ));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween =
        ColorTween(begin: theme.canvasColor, end: theme.primaryColor);

    final homePage = HomePage.of(context);
    final heroAnimation = homePage.heroAnimation;
    final headerHeightTween =
        Tween<double>(begin: 220, end: homePage.headerMinHeight);
    final buttonBurHeightTween = EdgeInsetsTween(
        begin: EdgeInsets.only(top: homePage.headerMinHeight),
        end: EdgeInsets.zero);
    final elevationTween = Tween<double>(begin: 0, end: homePage.elevation);

    final iconTheme = ThemeService.of(context).appBarIconTheme;
    final settingsButtonOpacity =
        Tween(begin: 1.0, end: 0.0).animate(homePage.animation);
    final settingsButtonColorTween = ColorTween(
        begin: theme.brightness == Brightness.dark
            ? iconTheme.color
            : theme.iconTheme.color,
        end: iconTheme.color);

    final borderRadius = (theme.cardTheme.shape as RoundedRectangleBorder)
        .borderRadius as BorderRadius;
    final borderRadiusTween = Tween<BorderRadius>(
        begin: BorderRadius.only(bottomLeft: Radius.zero),
        end: BorderRadius.only(bottomLeft: borderRadius.bottomRight));

    final paddingTween = Tween<EdgeInsets>(
        begin: EdgeInsets.zero, end: EdgeInsets.only(left: homePage.padding));

    return AnimatedBuilder(
      animation: heroAnimation,
      builder: (context, child) {
        return Padding(
          padding: paddingTween.evaluate(heroAnimation),
          child: Material(
            animationDuration: Duration.zero,
            color: colorTween.evaluate(heroAnimation),
            elevation: elevationTween.evaluate(heroAnimation),
            borderRadius: borderRadiusTween.evaluate(heroAnimation),
            child: Stack(
              children: [
                Padding(
                  padding: buttonBurHeightTween.evaluate(heroAnimation),
                  child: SizedBox(
                    height: headerHeightTween.evaluate(heroAnimation),
                    child: Align(
                      alignment: _headerAlignmentTween.evaluate(heroAnimation),
                      child: child,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const _Hit(),
                    SizedBox(
                      width: 72,
                      child: FadeTransition(
                        opacity: settingsButtonOpacity,
                        child: ButtonBar(
                          children: [
                            IconButton(
                              tooltip:
                                  StandardLocalizations.of(context).settings,
                              icon: Icon(
                                Icons.settings,
                                color: settingsButtonColorTween
                                    .evaluate(heroAnimation),
                              ),
                              onPressed: homePage.open,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _personLogoAnimation,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const _Logo(),
            ),
          ),
          const SizedBox(width: 48),
          SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: _titleAnimation,
            child: FadeTransition(
              opacity: _titleAnimation,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizeTransition(
                        axis: Axis.vertical,
                        sizeFactor: _titleSize,
                        child: SizeTransition(
                          axis: Axis.horizontal,
                          sizeFactor: _titleSize,
                          child: FadeTransition(
                            opacity: _titleOpacity,
                            child: Text(
                              StandardLocalizations.of(context).profile,
                              style: theme.textTheme.headline1,
                            ),
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _linksSizeAnimation,
                        child: FadeTransition(
                          opacity: _linksOpacityAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                const _GithubButton(),
                                const SizedBox(width: 8),
                                const _MailButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hit extends StatelessWidget {
  const _Hit({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final channel = NativeChannel.of(context);
    final future = channel.getBrowserType();
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(),
          );
        final browser = snapshot.data;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: browser == 'Chrome'
              ? const SizedBox()
              : RaisedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        StandardLocalizations.of(context)
                            .useChromeForBetterExperiment,
                        style: theme.textTheme.caption),
                  ),
                ),
        );
      },
    );
  }
}

class _GithubButton extends StatelessWidget {
  static const _url = 'https://github.com/JohnGu9';
  const _GithubButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final elevation = HomePage.of(context).elevation;
    return Tooltip(
      message: StandardLocalizations.of(context).visit,
      child: DetailButton(
        elevation: elevation,
        simple: const Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Image(
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
    final elevation = HomePage.of(context).elevation;
    return Tooltip(
      message: StandardLocalizations.of(context).copy,
      child: DetailButton(
        elevation: elevation,
        simple: const Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Image(
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
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

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

  void _onHover(bool value) {
    if (!mounted) return;
    _controller.animateWith(SpringSimulation(
      spring,
      _controller.value,
      value ? 1.0 : 0.0,
      _controller.velocity,
    ));
  }

  void _onTap() {
    return HomePage.of(context).scrollTo(0);
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
              elevation: 4.0,
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration.zero,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                side: BorderSide(
                    color: theme.toggleableActiveColor,
                    width: _borderSideWidth.value),
              ),
              child: child,
            );
          },
          child: Ink.image(
            image: Constants.personLogoImage,
            child: InkWell(
              onTap: _onTap,
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
            color: shouldBarrier ? Colors.black38 : Colors.transparent),
        child: child,
      ),
    );
  }
}

class _FloatIndex extends StatefulWidget {
  const _FloatIndex({Key key}) : super(key: key);

  @override
  _FloatIndexState createState() => _FloatIndexState();
}

class _FloatIndexState extends State<_FloatIndex>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _introController;

  Animation<double> get _mainIndexAnimation {
    return CurvedAnimation(
      curve: const Interval(0.4, 1),
      parent: _introController,
    );
  }

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(vsync: this);
    Future.delayed(const Duration(seconds: 1), () async {
      if (mounted) {
        _introController.animateTo(1.0, duration: const Duration(seconds: 3));
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween = ColorTween(
        begin: theme.primaryColor,
        end: theme.brightness == Brightness.dark
            ? theme.canvasColor
            : theme.primaryColor);
    final homePage = HomePage.of(context);
    final heroAnimation =
        Tween(begin: 1.0, end: 0.0).animate(homePage.heroAnimation);
    final headerHeightTween =
        Tween<double>(begin: 200, end: homePage.headerMinHeight);
    final buttonBurHeightTween = EdgeInsetsTween(
        begin: EdgeInsets.only(top: homePage.headerMinHeight),
        end: EdgeInsets.zero);
    final elevationTween = Tween(begin: homePage.elevation, end: 0.0);

    return TransitionBarrier(
      animation: heroAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: buttonBurHeightTween.begin,
            child: SizeTransition(
              axis: Axis.vertical,
              sizeFactor: heroAnimation,
              child: SizedBox(height: headerHeightTween.begin),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final rightPadding = Tween<double>(
                        begin: constraints.maxWidth *
                            (1 - homePage.indexSpaceRate),
                        end: 0.0)
                    .animate(heroAnimation);
                final roundPadding = EdgeInsetsTween(
                        begin: EdgeInsets.all(homePage.padding),
                        end: EdgeInsets.zero)
                    .animate(heroAnimation);
                return AnimatedBuilder(
                  animation: heroAnimation,
                  builder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.only(right: rightPadding.value),
                      child: Padding(
                        padding: roundPadding.value,
                        child: Material(
                          animationDuration: Duration.zero,
                          elevation: elevationTween.evaluate(heroAnimation),
                          shape: theme.cardTheme.shape,
                          clipBehavior: Clip.hardEdge,
                          color: colorTween.evaluate(heroAnimation),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: FadeTransition(
                    opacity: _mainIndexAnimation,
                    child: GroupAnimationService.passiveHost(
                      animation: _mainIndexAnimation,
                      child: _HeroGrid(
                        animation: heroAnimation,
                        children: const [
                          GroupAnimationService.client(
                            builder: _animatedItemBuilder,
                            child: _BackgroundCard(),
                          ),
                          GroupAnimationService.client(
                            builder: _animatedItemBuilder,
                            child: _SkillCard(),
                          ),
                          GroupAnimationService.client(
                            builder: _animatedItemBuilder,
                            child: _OtherCard(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  static final _offsetTween =
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
  static Widget _animatedItemBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    return SlideTransition(
      position: _offsetTween.animate(
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

class _HeroGrid extends StatelessWidget {
  const _HeroGrid({Key key, this.children, this.animation}) : super(key: key);
  final List<Widget> children;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight / children.length;
        final width = constraints.maxWidth / children.length;
        final List<EdgeInsetsTween> paddings = [
          for (int i = 0; i < children.length; i++)
            EdgeInsetsTween(
              begin: EdgeInsets.only(
                top: i * height,
                bottom: (children.length - i - 1) * height,
              ),
              end: EdgeInsets.only(
                left: i * width,
                right: (children.length - i - 1) * width,
              ),
            ),
        ];
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                for (int i = 0; i < children.length; i++)
                  Padding(
                    padding: paddings[i].evaluate(animation),
                    child: children[i],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CardDecoratedBox extends StatefulWidget {
  const _CardDecoratedBox({
    Key key,
    @required this.child,
    @required this.pageIndex,
    @required this.description,
    @required this.background,
  }) : super(key: key);

  final Widget child;
  final Widget description;
  final int pageIndex;
  final Widget background;

  @override
  __CardDecoratedBoxState createState() => __CardDecoratedBoxState();
}

class __CardDecoratedBoxState extends State<_CardDecoratedBox>
    with TickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;
  AnimationController _onHoverController;

  ValueListenable<int> _onPageChanged;
  _onPageChangedListener() {
    final shouldExpand = _onPageChanged.value == widget.pageIndex;
    _controller.animateWith(SpringSimulation(
      spring,
      _controller.value,
      shouldExpand ? _controller.upperBound : _controller.lowerBound,
      _controller.velocity,
    ));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _onHoverController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    _onPageChanged?.removeListener(_onPageChangedListener);
    _onPageChanged = HomePage.of(context).onPageChanged;
    _onPageChanged.addListener(_onPageChangedListener);
    _onPageChangedListener();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _onPageChanged?.removeListener(_onPageChangedListener);
    _onHoverController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    return HomePage.of(context).scrollTo(widget.pageIndex);
  }

  void _onHover(bool value) {
    _onHoverController.animateWith(SpringSimulation(spring,
        _onHoverController.value, value ? 1 : 0, _onHoverController.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.toggleableActiveColor;
    final colorTween = ColorTween(
        begin: theme.selectedRowColor.withOpacity(0.0),
        end: theme.selectedRowColor.withOpacity(0.12));
    final homePage = HomePage.of(context);
    final heroAnimation =
        Tween(begin: 1.0, end: 0.0).animate(homePage.heroAnimation);
    final themeService = ThemeService.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: Tween(begin: 0.1, end: 0.2).animate(_onHoverController),
          child: widget.background,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.centerRight,
              child: FadeTransition(
                opacity: _controller,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      color: activeColor,
                      width: constraints.maxWidth * _controller.value,
                      height: constraints.maxHeight,
                    );
                  },
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _onHoverController,
          builder: (context, child) {
            return Container(
              color: colorTween.evaluate(_onHoverController),
              child: child,
            );
          },
          child: InkWell(
            onTap: _onTap,
            onHover: _onHover,
            hoverColor: Colors.transparent,
            child: IconTheme(
              data: themeService.appBarIconTheme,
              child: DefaultTextStyle(
                style: themeService.sideStyle,
                child: SlideTransition(
                  position: Tween(
                    begin: Offset.zero,
                    end: const Offset(0, -0.06),
                  ).animate(_onHoverController),
                  child: Column(
                    children: [
                      Expanded(child: widget.child),
                      FadeTransition(
                        opacity: Tween(begin: 0.3, end: 0.9)
                            .animate(_onHoverController),
                        child: ScaleTransition(
                          alignment: Alignment.topCenter,
                          scale: Tween(begin: 1.0, end: 1.2)
                              .animate(_onHoverController),
                          child: CustomSizeTransition(
                            crossAxisAlignment: 0.0,
                            axis: Axis.vertical,
                            sizeFactor: heroAnimation,
                            child: FadeTransition(
                              opacity: heroAnimation,
                              child: widget.description,
                            ),
                          ),
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
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  const _BackgroundCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardDecoratedBox(
      pageIndex: 1,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.assignment_ind),
              Text(localization.background),
            ],
          ),
        ),
      ),
      description: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Text(
          localization.backgroundDescription,
        ),
      ),
      background: const Image(
        image: Constants.backgroundImage,
        filterQuality: FilterQuality.none,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardDecoratedBox(
      pageIndex: 2,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.build),
              Text(localization.skill),
            ],
          ),
        ),
      ),
      description: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Text(localization.skillDescription),
      ),
      background: const Image(
        image: Constants.skillImage,
        filterQuality: FilterQuality.none,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _OtherCard extends StatelessWidget {
  const _OtherCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardDecoratedBox(
      pageIndex: 3,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.scatter_plot),
              Text(localization.other),
            ],
          ),
        ),
      ),
      description: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Text(localization.otherDescription),
      ),
      background: const Image(
        image: Constants.otherImage,
        filterQuality: FilterQuality.none,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ScrollBarrier extends StatefulWidget {
  const _ScrollBarrier({Key key, this.child, this.page}) : super(key: key);
  final Widget child;
  final int page;

  @override
  __ScrollBarrierState createState() => __ScrollBarrierState();
}

class __ScrollBarrierState extends State<_ScrollBarrier> {
  ValueListenable<bool> _isScrollingNotifier;
  ValueListenable<int> _onPageChanged;
  Animation<double> _heroAnimation;
  bool _show = false;
  _listener([value]) {
    setState(() {
      _show = _show ||
          (!_isScrollingNotifier.value &&
              _onPageChanged.value == widget.page &&
              _heroAnimation.status == AnimationStatus.completed);
    });
  }

  @override
  void didChangeDependencies() {
    _isScrollingNotifier?.removeListener(_listener);
    _onPageChanged?.removeListener(_listener);
    _heroAnimation?.removeStatusListener(_listener);
    final homePage = HomePage.of(context);
    _isScrollingNotifier = homePage.isScrollingNotifier;
    _onPageChanged = homePage.onPageChanged;
    _heroAnimation = homePage.heroAnimation;
    _listener();
    _isScrollingNotifier.addListener(_listener);
    _onPageChanged.addListener(_listener);
    _heroAnimation.addStatusListener(_listener);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _isScrollingNotifier?.removeListener(_listener);
    _onPageChanged?.removeListener(_listener);
    _heroAnimation?.removeStatusListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _show ? widget.child : const SizedBox();
  }
}
