import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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
  static const _settingsPageWidth = 450.0;
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

class _Content extends StatelessWidget {
  const _Content({Key key, this.animation}) : super(key: key);
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme,
            title: Text(StandardLocalizations.of(context).home),
            actions: [
              IconButton(
                onPressed: () {
                  return HomePage.of(context).pushSettingsPage();
                },
                icon: FadeTransition(
                  opacity: Tween(begin: 1.0, end: 0.0).animate(animation),
                  child: const Icon(Icons.settings),
                ),
              ),
            ],
          )
        ],
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
