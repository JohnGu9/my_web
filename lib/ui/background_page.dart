import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/core/services/spring_provide_service.dart';
import 'package:my_web/ui/widgets/delay_show.dart';

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
            child: ValueListenableBuilder<int>(
              valueListenable: homePage.onPageChanged,
              builder: (context, value, child) {
                return DelayShow(
                  show: value == 1,
                  child: const _Content(),
                  delay: const Duration(milliseconds: 500),
                );
              },
            ),
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
      ..animateTo(1.0, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final titleStyle =
        Theme.of(context).textTheme.headline4.copyWith(color: Colors.white);
    return GroupAnimationService.passiveHost(
      animation: _controller,
      child: FadeTransition(
        opacity: _controller,
        child: Row(
          children: [
            Expanded(
              child: GroupAnimationService.client(
                builder: (context, animation, child) {
                  return _Education(animation: animation);
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: GroupAnimationService.client(
                  builder: _animatedItemBuilder,
                  child: Center(
                    child: Text(
                      localization.experiment,
                      style: titleStyle,
                    ),
                  ),
                ),
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
    final position = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(curvedAnimation);
    return SlideTransition(
      position: position,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class _Education extends StatefulWidget {
  const _Education({Key key, this.animation}) : super(key: key);

  final Animation<double> animation;

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
    final curvedAnimation =
        CurvedAnimation(parent: widget.animation, curve: Curves.fastOutSlowIn);
    final position = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(curvedAnimation);

    return InkWell(
      onTap: _onTap,
      onHover: _onHover,
      hoverColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            foregroundDecoration:
                BoxDecoration(color: colorTween.evaluate(_controller)),
            child: FractionallySizedBox(
              widthFactor: Tween(
                begin: 2.0 / 3.0,
                end: 4.0 / 5.0,
              ).evaluate(_controller),
              child: child,
            ),
          );
        },
        child: SlideTransition(
          position: position,
          child: FadeTransition(
            opacity: widget.animation,
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
                  const SliverToBoxAdapter(child: _University()),
                  const SliverToBoxAdapter(child: _Major()),
                ],
              ),
            ),
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
            title: Text(localization.JNU),
            subtitle: Text(localization.university),
            trailing: const Icon(Icons.school),
            onTap: _onTap,
          ),
          SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _controller,
            child: SizedBox(
              height: 100,
              child: Placeholder(),
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
            child: SizedBox(
              height: 100,
              child: Placeholder(),
            ),
          ),
        ],
      ),
    );
  }
}
