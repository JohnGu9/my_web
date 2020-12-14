import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_web/core/constants.dart';
import 'package:my_web/core/core.dart';
import 'package:my_web/core/native/native_channel.dart';
import 'package:my_web/ui/dialogs/dialogs.dart';
import 'package:my_web/ui/widgets/animated_safe_area.dart';
import 'package:my_web/ui/widgets/scope_navigator.dart';
import 'package:my_web/ui/widgets/mixin/route_animation_controller_mixin.dart';

import 'other_page.dart';
import 'settings_page.dart';
import 'background_page.dart';
import 'skill_page.dart';

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
        SingleTickerProviderStateMixin,
        SpringProvideStateMixin,
        RouteAnimationController {
  Widget _child = const SizedBox();

  _showBottomSheet(Widget child) {
    controller.animationWithSpring(spring, 1);
    setState(() {
      _child = child;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return _HomePage(
      state: this,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expandedHeight = constraints.maxWidth * (2 / 3);
          final factor = (108 / expandedHeight).clamp(0.0, expandedHeight);
          return Scaffold(
            body: ScopeNavigatorProxy(
              builder: (context, noRouteLayer, child) {
                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    IgnorePointer(
                      ignoring: !noRouteLayer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        foregroundDecoration: BoxDecoration(
                          color: noRouteLayer
                              ? Colors.transparent
                              : Colors.black38,
                        ),
                        child: child,
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            child: ScopeNavigator(
                              spring: SpringProvideService.of(context),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: AnimatedSafeArea(
                            animation: Tween(
                              begin: 1.0,
                              end: 0.0,
                            ).animate(controller),
                            child: Align(
                              alignment: const Alignment(0.85, 0.0),
                              child: const _MailButton(),
                            ),
                          ),
                        ),
                        SizeTransition(
                          axis: Axis.vertical,
                          sizeFactor: controller,
                          axisAlignment: -1.0,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: constraints.maxHeight * 0.8),
                                child: _child), // bottom sheet
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              child: Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.canvasColor.withOpacity(0.0),
                      theme.canvasColor.withOpacity(0.0),
                      theme.canvasColor.withOpacity(1.0),
                      theme.canvasColor.withOpacity(1.0),
                    ],
                    stops: [
                      0.0,
                      1.0 - 120 / constraints.maxHeight,
                      1.0 - 45 / constraints.maxHeight,
                      1.0,
                    ],
                  ),
                ),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Container(
                      foregroundDecoration: BoxDecoration(
                          color: ColorTween(
                                  begin: Colors.transparent,
                                  end: Colors.black38)
                              .evaluate(controller)),
                      child: GestureDetector(
                        onTap: controller.value > 0.001
                            ? () {
                                final navigator = Navigator.of(context);
                                if (navigator.canPop()) navigator.pop();
                              }
                            : null,
                        child: AbsorbPointer(
                            absorbing: controller.value > 0.001, child: child),
                      ),
                    );
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        automaticallyImplyLeading: false,
                        expandedHeight: expandedHeight,
                        leading: const _FullScreenButton(),
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: false,
                          title: Text(localizations.profile),
                          background: Container(
                            foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                  0.0,
                                  1.0 - factor,
                                  1.0
                                ],
                                    colors: [
                                  theme.primaryColor.withOpacity(0.0),
                                  theme.primaryColor.withOpacity(0.0),
                                  theme.primaryColor.withOpacity(1.0),
                                ])),
                            child: const Image(
                              image: Constants.personLogoImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        actions: [
                          Material(
                            elevation: 4.0,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            color: theme.toggleableActiveColor,
                            child: IconButton(
                              tooltip: 'GitHub',
                              icon: const Image(
                                image: Constants.githubLogoImage,
                                fit: BoxFit.contain,
                              ),
                              onPressed: () {
                                const url = 'https://github.com/JohnGu9';
                                showVisitWebsiteDialog(context, url);
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Material(
                            elevation: 4.0,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            color: theme.toggleableActiveColor,
                            child: IconButton(
                              tooltip: 'Medium',
                              icon: const Image(
                                image: Constants.mediumLogoImage,
                                fit: BoxFit.contain,
                              ),
                              onPressed: () {
                                const url = 'https://johngu9.medium.com/';
                                showVisitWebsiteDialog(context, url);
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          const _SettingButton(),
                        ],
                      ),
                      const _ListView(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FullScreenButton extends StatelessWidget {
  const _FullScreenButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final channel = NativeChannel.of(context);
    print(channel.isWeb);
    if (!channel.isWeb) return const SizedBox();
    final fullscreen = channel.fullscreenChanged;
    return ValueListenableBuilder<bool>(
      valueListenable: fullscreen,
      builder: (context, value, child) {
        return IconButton(
          tooltip: 'Fullscreen',
          icon: value
              ? const Icon(Icons.fullscreen_exit)
              : const Icon(Icons.fullscreen),
          onPressed: () {
            return value
                ? NativeChannel.of(context).exitFullscreen()
                : NativeChannel.of(context).requestFullscreen();
          },
        );
      },
    );
  }
}

class _HomePage extends InheritedWidget {
  const _HomePage({Key key, Widget child, this.state})
      : super(key: key, child: child);
  final _HomePageState state;

  showBottomSheet({@required Widget child}) {
    return state._showBottomSheet(child);
  }

  @override
  bool updateShouldNotify(covariant _HomePage oldWidget) {
    return state != oldWidget.state;
  }
}

class _SettingButton extends StatelessWidget {
  const _SettingButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    final themeService = ThemeService.of(context);
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        return HomePage.of(context).showBottomSheet(
          child: SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Card(child: SettingsPage()),
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      final navigator = Navigator.of(context);
                      if (navigator.canPop()) navigator.pop();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          localizations.cancel,
                          style: themeService.textButtonStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MailButton extends StatefulWidget {
  const _MailButton({Key key}) : super(key: key);

  @override
  __MailButtonState createState() => __MailButtonState();
}

class __MailButtonState extends State<_MailButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static _onTap() async {
    const _address = 'johngustyle@outlook.com';
    final Uri params = Uri(
      scheme: 'mailto',
      path: _address,
    );
    String url = params.toString();
    if (await canLaunch(url)) await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween(begin: const Offset(1.0, 0), end: Offset.zero)
            .animate(_controller),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.mail),
            label: Text(localizations.contactMe),
            onPressed: _onTap,
          ),
        ),
      ),
    );
  }
}

class _ListView extends StatefulWidget {
  const _ListView({Key key}) : super(key: key);

  @override
  __ListViewState createState() => __ListViewState();
}

class __ListViewState extends State<_ListView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.animateTo(1.0, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    return GroupAnimationService.passiveHost(
      animation: _controller,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: SliverList(
          delegate: SliverChildListDelegate.fixed([
            ScopeHero(
              child: _Card(
                title: Text(localizations.background),
                subtitle: Text(localizations.backgroundDescription),
                image: Constants.backgroundImage,
                page: const BackgroundPage(),
              ),
            ),
            ScopeHero(
              child: _Card(
                title: Text(localizations.skill),
                subtitle: Text(localizations.skillDescription),
                image: Constants.skillImage,
                page: const SkillPage(),
              ),
            ),
            ScopeHero(
              child: _Card(
                title: Text(localizations.other),
                subtitle: Text(localizations.otherDescription),
                image: Constants.otherImage,
                page: const OtherPage(),
              ),
            ),
            const SizedBox(height: 120)
          ]),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.image,
      @required this.page})
      : assert(subtitle != null),
        super(key: key);

  final Widget title;
  final Widget subtitle;
  final ImageProvider image;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevation = theme.cardTheme.elevation ?? 4.0;
    return GroupAnimationService.client(
      builder: (context, animation, child) {
        final CurvedAnimation curvedAnimation =
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0.2, 1.0),
              ),
              child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          shape: theme.cardTheme.shape,
          clipBehavior: Clip.hardEdge,
          elevation: elevation,
          child: InkWell(
            onTap: () {
              final navigator = ScopeNavigator.of(context);
              if (navigator.available) {
                navigator.push(ScopePageRoute(
                  backgroundBuilder: (context, animation, secondaryAnimation) {
                    return const SizedBox();
                  },
                  builder: (context, animation, secondaryAnimation) {
                    return AnimatedSafeArea(
                      animation: animation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Material(
                          elevation: elevation,
                          shape: theme.cardTheme.shape,
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image(
                                    image: image,
                                    color: Color.fromRGBO(255, 255, 255, 0.3),
                                    colorBlendMode: BlendMode.modulate,
                                    fit: BoxFit.cover,
                                    height: 180,
                                    width: double.infinity,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizeTransition(
                                            sizeFactor: animation,
                                            axis: Axis.horizontal,
                                            axisAlignment: 1.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  final navigator =
                                                      ScopeNavigator.of(
                                                          context);
                                                  if (navigator.canPop())
                                                    navigator.pop();
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AppBar(
                                              automaticallyImplyLeading: false,
                                              centerTitle: false,
                                              textTheme: theme.textTheme,
                                              title: title,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(subtitle: subtitle),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(child: page),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ));
              }
            },
            child: Stack(
              children: [
                Image(
                  image: image,
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  colorBlendMode: BlendMode.modulate,
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
                Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      textTheme: theme.textTheme,
                      title: title,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    ListTile(subtitle: subtitle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
