import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:my_web/core/basic/constants.dart';
import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/core/services/spring_provide_service.dart';
import 'package:my_web/ui/dialogs/visit_website_dialog.dart';

import 'home_page.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key key}) : super(key: key);
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
              bottom: homePage.padding),
          child: Material(
            clipBehavior: Clip.hardEdge,
            elevation: homePage.elevation,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  bottomLeft: borderRadius.bottomLeft),
            ),
            child: HomePage.scrollBarrier(page: 1, child: const _Content()),
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
    with SingleTickerProviderStateMixin<_Content> {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0, duration: const Duration(milliseconds: 2400));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GroupAnimationService.passiveHost(
      animation: _controller,
      child: FadeTransition(
        opacity: _controller,
        child: Row(
          children: const [
            Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: const _Education(),
              ),
            ),
            Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: const _Experiment(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _animatedItemBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    final curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
    final position = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(curvedAnimation);
    return GroupAnimationService.passiveHost(
      animation: animation,
      child: SlideTransition(
        position: position,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}

class _Education extends StatefulWidget {
  const _Education({Key key}) : super(key: key);

  @override
  __EducationState createState() => __EducationState();
}

class __EducationState extends State<_Education>
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
    final colorTween = ColorTween(
        begin: theme.selectedRowColor.withOpacity(0.0),
        end: theme.selectedRowColor.withOpacity(0.12));
    final localization = StandardLocalizations.of(context);
    final titleStyle = theme.textTheme.headline4.copyWith(color: Colors.white);

    return InkWell(
      onTap: _onTap,
      onHover: _onHover,
      hoverColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: colorTween.evaluate(_controller),
            child: FractionallySizedBox(
              widthFactor: Tween(
                begin: 2.0 / 3.0,
                end: 4.0 / 5.0,
              ).evaluate(_controller),
              child: child,
            ),
          );
        },
        child: Center(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    localization.education,
                    style: titleStyle,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                  child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _University(),
              )),
              const SliverToBoxAdapter(
                  child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _Major(),
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 100))
            ],
          ),
        ),
      ),
    );
  }
}

class _University extends StatefulWidget {
  const _University({Key key}) : super(key: key);

  @override
  __UniversityState createState() => __UniversityState();
}

class __UniversityState extends State<_University>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  bool _expanded;
  @override
  void initState() {
    super.initState();
    _expanded = false;
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _expanded = !_expanded;
    _controller.animateWith(SpringSimulation(spring, _controller.value,
        _expanded ? 1.0 : 0.0, _controller.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            title: Text(localization.jnu),
            subtitle: Text(localization.university),
            trailing: const Icon(Icons.school),
            onTap: _onTap,
          ),
          SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _controller,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Image(
                      image: Constants.jinanLogoImage,
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Tooltip(
                            message: localization.visit,
                            child: Chip(
                              label: const Text(
                                'https://www.jnu.edu.cn',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              useDeleteButtonTooltip: false,
                              deleteIcon: const Icon(Icons.near_me),
                              onDeleted: () {
                                return showVisitWebsiteDialog(
                                    context, 'https://www.jnu.edu.cn');
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                              label: Text(
                            'GuangDong - GuangZhou',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                              label: Text(
                            '211',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                        ),
                      ],
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

class _Major extends StatefulWidget {
  const _Major({Key key}) : super(key: key);

  @override
  __MajorState createState() => __MajorState();
}

class __MajorState extends State<_Major>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  bool _expanded;
  @override
  void initState() {
    super.initState();
    _expanded = false;
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _expanded = !_expanded;
    _controller.animateWith(SpringSimulation(spring, _controller.value,
        _expanded ? 1.0 : 0.0, _controller.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            title: Text(localization.internetOfThings),
            subtitle: Text(localization.fourYearFullTime),
            trailing: const Icon(Icons.book),
            onTap: _onTap,
          ),
          SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _controller,
            child: FadeTransition(
              opacity: _controller,
              child: Column(
                children: [
                  AppBar(
                    textTheme: theme.textTheme,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(localization.coverage),
                  ),
                  ListTile(
                    title: Text(localization.signalAndCommunication),
                  ),
                  ListTile(
                    title: Text(localization.electronicCircuit),
                  ),
                  ListTile(
                    title: Text(localization.computerScience),
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

class _Experiment extends StatefulWidget {
  const _Experiment({Key key}) : super(key: key);

  @override
  __ExperimentState createState() => __ExperimentState();
}

class __ExperimentState extends State<_Experiment>
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
    final localization = StandardLocalizations.of(context);
    final titleStyle = theme.textTheme.headline4.copyWith(color: Colors.white);
    final colorTween = ColorTween(
        begin: theme.selectedRowColor.withOpacity(0.0),
        end: theme.selectedRowColor.withOpacity(0.12));
    return InkWell(
      onTap: _onTap,
      onHover: _onHover,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: colorTween.evaluate(_controller),
            child: FractionallySizedBox(
              widthFactor: Tween(
                begin: 2.0 / 3.0,
                end: 4.0 / 5.0,
              ).evaluate(_controller),
              child: child,
            ),
          );
        },
        child: Center(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    localization.experiment,
                    style: titleStyle,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _EmbeddedEngineer(),
                ),
              ),
              const SliverToBoxAdapter(
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: _CommunicationsEngineer(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100))
            ],
          ),
        ),
      ),
    );
  }
}

class _EmbeddedEngineer extends StatelessWidget {
  const _EmbeddedEngineer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(localization.embeddedEngineer),
        trailing: Chip(label: Text(localization.practice)),
      ),
    );
  }
}

class _CommunicationsEngineer extends StatelessWidget {
  const _CommunicationsEngineer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(localization.communicationsEngineer),
      ),
    );
  }
}

Widget _animatedItemBuilder(
    BuildContext context, Animation<double> animation, Widget child) {
  final curvedAnimation =
      CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
  return ScaleTransition(
    scale: curvedAnimation,
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
