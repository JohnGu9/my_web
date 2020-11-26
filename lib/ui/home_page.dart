import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

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
  PageController _pageController;
  ValueNotifier<int> _currentPage;

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
    _pageController = PageController();
    _currentPage = ValueNotifier(0);
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
          child: ScopeNavigator(
            spring: SpringProvideService.of(context),
            child: Material(
              elevation: 16.0,
              child: _HomePage(
                state: this,
                child: Stack(
                  children: [
                    PageView(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      onPageChanged: (value) {
                        _currentPage.value = value;
                      },
                      children: const [
                        const SizedBox(),
                        const BackgroundPage(),
                        const SkillPage(),
                        const OtherPage(),
                      ],
                    ),
                    const _FloatIndex(),
                    const _Header(),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 100,
                        child: FadeTransition(
                          opacity: Tween(
                            begin: 1.0,
                            end: 0.0,
                          ).animate(_controller),
                          child: ButtonBar(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: open)
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
    );
  }
}

final _headerHeightTween = Tween<double>(begin: 200, end: 72);
final _buttonBurHeightTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(top: 72), end: EdgeInsets.zero);
final _headerAlignmentTween =
    Tween<Alignment>(begin: Alignment.center, end: Alignment(-0.9, 0));
final _elevationTween = Tween<double>(begin: 0, end: 4.0);

class _Header extends StatefulWidget {
  const _Header({Key key}) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header>
    with TickerProviderStateMixin<_Header> {
  AnimationController _controller;
  AnimationController _animationController;

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

  SpringDescription get _spring {
    return SpringProvideService.of(context);
  }

  ValueListenable<int> _onPageChanged;
  _onPageChangedListener() {
    final shouldExpanded = _onPageChanged.value == 0;
    _animationController.animateWith(SpringSimulation(
      _spring,
      _animationController.value,
      shouldExpanded
          ? _animationController.lowerBound
          : _animationController.upperBound,
      _animationController.velocity,
    ));
  }

  Animation<double> _titleSize;
  Animation<double> _titleOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animationController = AnimationController(vsync: this);
    _titleSize = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _titleOpacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3),
    ));
    Future.delayed(const Duration(milliseconds: 25), () async {
      if (mounted) {
        _controller.animateTo(1.0, duration: const Duration(seconds: 3));
      }
    });
  }

  @override
  void didChangeDependencies() {
    _onPageChanged?.removeListener(_onPageChangedListener);
    final homePage = HomePage.of(context);
    _onPageChanged = homePage.onPageChanged;
    _onPageChanged.addListener(_onPageChangedListener);
    _onPageChangedListener();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween = ColorTween(
        begin: theme.canvasColor.withOpacity(0.0), end: theme.primaryColor);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Material(
          color: colorTween.evaluate(_animationController),
          elevation: _elevationTween.evaluate(_animationController),
          animationDuration: Duration.zero,
          child: Padding(
            padding: _buttonBurHeightTween.evaluate(_animationController),
            child: SizedBox(
              height: _headerHeightTween.evaluate(_animationController),
              child: Align(
                alignment: _headerAlignmentTween.evaluate(_animationController),
                child: child,
              ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            StandardLocalizations.of(context).profile,
                            style: theme.textTheme.headline1,
                          ),
                        ),
                      ),
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

  scrollTo(int page) {
    return state._pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  ValueListenable<int> get onPageChanged {
    return state._currentPage;
  }

  open() {
    return state.open();
  }

  @override
  bool updateShouldNotify(covariant _HomePage oldWidget) {
    return state != oldWidget.state;
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
              elevation: 4.0,
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
              onTap: () {
                return HomePage.of(context).scrollTo(0);
              },
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

class _FloatIndex extends StatefulWidget {
  const _FloatIndex({Key key}) : super(key: key);

  @override
  _FloatIndexState createState() => _FloatIndexState();
}

class _FloatIndexState extends State<_FloatIndex>
    with TickerProviderStateMixin<_FloatIndex> {
  AnimationController _controller;
  AnimationController _animationController;

  Animation<double> get _mainIndexAnimation {
    return CurvedAnimation(
      curve: const Interval(0.6, 1),
      parent: _controller,
    );
  }

  SpringDescription get _spring {
    return SpringProvideService.of(context);
  }

  ValueListenable<int> _onPageChanged;
  _onPageChangedListener() {
    final shouldExpand = _onPageChanged.value == 0;
    _animationController.animateWith(SpringSimulation(
      _spring,
      _animationController.value,
      shouldExpand
          ? _animationController.upperBound
          : _animationController.lowerBound,
      _animationController.velocity,
    ));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animationController = AnimationController(vsync: this, value: 1.0);
    Future.delayed(const Duration(seconds: 1), () async {
      if (mounted) {
        _controller.animateTo(1.0, duration: const Duration(seconds: 3));
      }
    });
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
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween =
        ColorTween(begin: theme.primaryColor, end: theme.canvasColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: _buttonBurHeightTween.begin,
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _animationController,
            child: SizedBox(height: _headerHeightTween.begin),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final rightPadding = Tween<double>(
                      begin: constraints.maxWidth * 4.0 / 5.0, end: 0.0)
                  .animate(_animationController);
              final roundPadding = EdgeInsetsTween(
                      begin: const EdgeInsets.all(16), end: EdgeInsets.zero)
                  .animate(_animationController);
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Padding(
                    padding: EdgeInsets.only(right: rightPadding.value),
                    child: Padding(
                      padding: roundPadding.value,
                      child: Material(
                        shape: theme.cardTheme.shape,
                        clipBehavior: Clip.hardEdge,
                        color: colorTween.evaluate(_animationController),
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
                      animation: _animationController,
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

class _BackgroundCard extends StatelessWidget {
  const _BackgroundCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return HomePage.of(context).scrollTo(1);
      },
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.assignment_ind),
              Text(StandardLocalizations.of(context).background),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return HomePage.of(context).scrollTo(2);
      },
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.build),
              Text(StandardLocalizations.of(context).skill),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtherCard extends StatelessWidget {
  const _OtherCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return HomePage.of(context).scrollTo(3);
      },
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.scatter_plot),
              Text(StandardLocalizations.of(context).other),
            ],
          ),
        ),
      ),
    );
  }
}
