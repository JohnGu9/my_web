import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

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

  _listener() {
    if (widget.controller.value > 0.75 && _isOpened == false) {
      _isOpened = true;
      _controller.animateTo(1.0);
    } else if (widget.controller.value - widget.controller.lowerBound < 0.01) {
      _isOpened = false;
      _controller.value = 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    widget.controller.addListener(_listener);
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
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 1.0,
      child: CustomScrollView(
        slivers: [
          GroupAnimationService.passiveHost(
            animation: _controller,
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
                    title: Text(locale.darkTheme),
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    title: Text(locale.language),
                  ),
                ),
                GroupAnimationService.client(
                  builder: _animationBuilder,
                  child: ListTile(
                    title: Text(locale.about),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _animationBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween(begin: const Offset(0.05, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
