import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/core/services/spring_provide_service.dart';
import 'package:my_web/ui/home_page.dart';
import 'package:my_web/ui/widgets/scope_navigator.dart';
import 'package:my_web/ui/widgets/transition_barrier.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({Key key}) : super(key: key);
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
            child: HomePage.scrollBarrier(page: 2, child: const _Content()),
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
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransitionBarrier(
      animation: _controller,
      child: ScopeNavigator(
        spring: spring,
        child: GroupAnimationService.passiveHost(
          animation: _controller,
          child: Row(
            children: [
              const Expanded(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _TechniqueStackCard(),
                ),
              ),
              const Expanded(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _ProgrammingLanguage(),
                ),
              ),
              const Expanded(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _SupportPlatform(),
                ),
              ),
              const Expanded(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _OtherStuff(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _animatedItemBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    final curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
    final position =
        Tween(begin: Offset(1, 0), end: Offset.zero).animate(curvedAnimation);
    return SlideTransition(
      position: position,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class _CardWrapper extends StatefulWidget {
  const _CardWrapper({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  __CardWrapperState createState() => __CardWrapperState();
}

class __CardWrapperState extends State<_CardWrapper>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {}

  void _onHover(bool value) {
    if (!mounted) return;
    _controller.animateWith(SpringSimulation(
        spring, _controller.value, value ? 1.0 : 0.0, _controller.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: InkWell(
        onTap: _onTap,
        onHover: _onHover,
        hoverColor: Colors.transparent,
        child: AnimatedBuilder(
          child: widget.child,
          animation: _controller,
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                cardTheme: theme.cardTheme.copyWith(
                  margin: EdgeInsetsTween(
                    begin: const EdgeInsets.all(6.0),
                    end: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 6.0),
                  ).evaluate(_controller),
                ),
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class _TechniqueStackCard extends StatelessWidget {
  const _TechniqueStackCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.techniqueStack),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text(localization.signalProcessing),
                    subtitle: Card(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          ListTile(
                              title:
                                  Text(localization.digitalSignalProcessing)),
                          ListTile(
                              title: Text(localization.digitalImageProcessing)),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(localization.programming),
                    subtitle: Card(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          ListTile(title: Text(localization.hardwareLanguage)),
                          ListTile(title: Text(localization.softwareLanguage)),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(localization.circuits),
                    subtitle: Card(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          ListTile(title: Text(localization.analogCircuits)),
                          ListTile(title: Text(localization.digitalCircuits)),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(localization.computerNetwork),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgrammingLanguage extends StatelessWidget {
  static const _languages = [
    'C/C++',
    'Java',
    'Kotlin',
    'Python',
    'Dart',
    'JavaScript',
    'VHDL',
  ];

  const _ProgrammingLanguage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.programmingLanguage),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (BuildContext context, int index) {
                final language = _languages[index];
                return Card(
                  child: ListTile(title: Text(language)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportPlatform extends StatelessWidget {
  const _SupportPlatform({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.supportedPlatform),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(localization.usedFramework)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Flutter'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('PyQt5'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('OpenCV'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Tensorflow'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Flask'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Electron'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(localization.embeddedSystem)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            const Chip(
                              avatar: const Icon(Icons.developer_board),
                              label: const Text('STM32'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(localization.desktop)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            const Chip(
                              avatar: const Icon(Icons.desktop_windows),
                              label: const Text('Windows'),
                            ),
                            const Chip(
                              avatar: const Icon(Icons.desktop_mac),
                              label: const Text('macOS'),
                            ),
                            const Tooltip(
                              message:
                                  "I prefer Ubuntu! CentOS and 'yum' is awful. ",
                              child: const Chip(
                                avatar:
                                    const Icon(Icons.desktop_windows_outlined),
                                label: const Text('Linux'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(localization.mobile)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            const Tooltip(
                              message:
                                  "I only have android phones when I was a student. Sorry IOS. ",
                              child: const Chip(
                                avatar: const Icon(Icons.android),
                                label: const Text('Android'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: ListTile(title: const Text("Web")),
                ),
                Card(
                  child: ListTile(title: const Text("FPGA")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherStuff extends StatelessWidget {
  const _OtherStuff({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.otherRelatedStuff),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text(localization.whatIsMyAdvantage),
                    subtitle: Card(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          localization.myAdvantageDescription,
                          style: theme.textTheme.caption,
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                          title: RichText(
                        text: TextSpan(
                            style: theme.textTheme.bodyText1,
                            children: [
                              TextSpan(text: localization.learning),
                              const TextSpan(text: ' / '),
                              TextSpan(text: localization.interest),
                            ]),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Swift'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Rust'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Go'),
                            ),
                            const Chip(
                              avatar: const FlutterLogo(),
                              label: const Text('Kubernetes'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
