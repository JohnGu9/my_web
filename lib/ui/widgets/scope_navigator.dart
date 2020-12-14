import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:listenable_list/listenable_list.dart';

import 'package:my_web/core/basic/region.dart';
import 'animation_controller_builder.dart';
import 'mixin/region_observer_mixin.dart';
import 'region_positioned.dart';

typedef Widget ScopePageRouteBuilder(BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation);

typedef Widget ScopePageRouteBackgroundBuilder(BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation);

typedef Widget _SecondaryAnimationBuilder(
  BuildContext context,
  bool noRouteLayer,
  Widget child,
);

extension on AnimationController {
  TickerFuture animationWithSpring(SpringDescription spring, double target) {
    return animateWith(SpringSimulation(spring, value, target, velocity));
  }
}

class ScopePageRoute {
  static _ScopePageRoute of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ScopePageRoute>();
  }

  static Widget _backgroundBuilder(BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation) {
    final color = ColorTween(begin: Colors.transparent, end: Colors.black38)
        .animate(animation);
    final routeStatus =
        context.dependOnInheritedWidgetOfExactType<_RouteStatus>();

    return IgnorePointer(
      ignoring: routeStatus.isPopped,
      child: GestureDetector(
        onTap: () {
          final navigator = ScopeNavigator.of(context);
          if (navigator.canPop()) navigator.pop();
        },
        child: AnimatedBuilder(
          animation: color,
          builder: (context, child) {
            return Container(color: color.value);
          },
        ),
      ),
    );
  }

  const ScopePageRoute({
    @required this.builder,
    this.backgroundBuilder = _backgroundBuilder,
  });
  final ScopePageRouteBuilder builder;
  final ScopePageRouteBackgroundBuilder backgroundBuilder;
}

class _ScopePageRoute extends InheritedWidget {
  const _ScopePageRoute({Key key, Widget child, this.state})
      : super(key: key, child: child);

  @visibleForTesting
  final _RouteLayerState state;

  Region get maxRegion {
    return state.widget.region;
  }

  Region get minRegion {
    return state.widget.hero?.region?.value ?? state.widget.region;
  }

  Animation<double> get animation {
    return state._controller;
  }

  @override
  bool updateShouldNotify(covariant _ScopePageRoute oldWidget) {
    return state != oldWidget.state;
  }
}

class _ScopeNavigator {
  static _ScopeNavigator of(BuildContext context) {
    final navigator = context.dependOnInheritedWidgetOfExactType<_Navigator>();
    final secondaryAnimation = context
        .dependOnInheritedWidgetOfExactType<_SecondaryAnimationController>()
        ?.controller;
    final hero = ScopeHero.of(context);
    return _ScopeNavigator._internal(
        context, navigator?.state, hero, secondaryAnimation);
  }

  _ScopeNavigator._internal(
      this._context, this._state, this.hero, this._secondaryAnimation);
  final BuildContext _context;
  final _ScopeNavigatorState _state;
  final AnimationController _secondaryAnimation;
  final _ScopeHeroState hero;

  bool get available {
    return _state != null;
  }

  Future<void> push(ScopePageRoute route) async {
    final newLayer = _Layer(route, _secondaryAnimation, Completer(), hero);
    _state._layers.add(newLayer);
    return newLayer.completer.future;
  }

  bool canPop() {
    final routeStatus =
        _context.dependOnInheritedWidgetOfExactType<_RouteStatus>();
    return routeStatus?.isPushed ?? false;
  }

  pop<T extends Object>([value]) {
    return Navigator.of(_context).pop<T>(value);
  }
}

class ScopeNavigator extends StatefulWidget {
  static _ScopeNavigator of(BuildContext context) {
    return _ScopeNavigator.of(context);
  }

  static Widget _builder(BuildContext context, bool available, Widget child) {
    return IgnorePointer(ignoring: !available, child: child);
  }

  const ScopeNavigator({
    Key key,
    this.builder = _builder,
    @required this.child,
    @required this.spring,
    this.region,
  }) : super(key: key);

  final Widget child;
  final SpringDescription spring;
  final Region region;
  final _SecondaryAnimationBuilder builder;

  @override
  _ScopeNavigatorState createState() => _ScopeNavigatorState();
}

class _ScopeNavigatorState extends State<ScopeNavigator> {
  ListenableList<_Layer> _layers;

  @override
  void initState() {
    super.initState();
    _layers = ListenableList()..addListener(_onLayersChanged);
  }

  @override
  void didChangeDependencies() {
    ScopeNavigatorProxy.of(context)?.export = this;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _layers.forEach((element) => element.dispose());
    _layers.dispose();
    super.dispose();
  }

  void _onLayersChanged() {
    ScopeNavigatorStatusChangedNotification().dispatch(context);
    _layers.added.forEach((key, element) {
      element.initState();
      element._isPopped.addListener(_onRouteStatusChanged);
    });
  }

  void _onRouteStatusChanged() => setState(() {
        ScopeNavigatorStatusChangedNotification().dispatch(context);
      });

  bool _onRemoveLayerNotification(_RemoveLayerNotification notification) {
    final layer = notification.layer;
    layer.dispose();
    _layers.remove(layer);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _Navigator(
      state: this,
      child: NotificationListener<_RemoveLayerNotification>(
        onNotification: _onRemoveLayerNotification,
        child: LayoutBuilder(builder: _layoutBuilder),
      ),
    );
  }

  Widget _layoutBuilder(BuildContext context, BoxConstraints constraints) {
    final region = widget.region ??
        Region.fromZero(
            width: constraints.maxWidth, height: constraints.maxHeight);
    return ValueListenableBuilder<List<_Layer>>(
      valueListenable: _layers,
      builder: (context, value, child) {
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            widget.builder(
              context,
              _layers
                  .every((element) => element._isPopped.value), // barrier off
              _RouteStatus(isPopped: false, child: widget.child),
            ),
            ..._layers.map((element) {
              return element.build(spring: widget.spring, region: region);
            })
          ],
        );
      },
    );
  }
}

class ScopeNavigatorProxy extends StatefulWidget {
  static _ScopeNavigatorProxy of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ScopeNavigatorProxy>();
  }

  const ScopeNavigatorProxy({Key key, @required this.builder, this.child})
      : super(key: key);
  final Widget child;
  final _SecondaryAnimationBuilder builder;

  @override
  _ScopeNavigatorProxyState createState() => _ScopeNavigatorProxyState();
}

class _ScopeNavigatorProxyState extends State<ScopeNavigatorProxy> {
  ValueNotifier<_ScopeNavigatorState> _proxy;
  _ScopeNavigatorState get client {
    return _proxy.value;
  }

  bool _shouldBarrier = false;

  @override
  void initState() {
    super.initState();
    _proxy = ValueNotifier(null)
      ..addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) setState(() {});
        });
      });
  }

  @override
  void dispose() {
    _proxy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ScopeNavigatorProxy(
      state: this,
      child: NotificationListener<ScopeNavigatorStatusChangedNotification>(
        onNotification: _onNotification,
        child: _Navigator(
          state: client,
          child: widget.builder(
            context,
            !_shouldBarrier,
            widget.child,
          ),
        ),
      ),
    );
  }

  bool _onNotification(ScopeNavigatorStatusChangedNotification notification) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted)
        setState(() {
          _shouldBarrier =
              client != null && client._layers.any((element) => element.pushed);
        });
    });
    return true;
  }
}

class ScopeNavigatorStatusChangedNotification extends Notification {}

class _ScopeNavigatorProxy extends InheritedWidget {
  const _ScopeNavigatorProxy({Key key, Widget child, this.state})
      : super(key: key, child: child);
  final _ScopeNavigatorProxyState state;

  set export(_ScopeNavigatorState newState) {
    state._proxy.value = newState;
  }

  @override
  bool updateShouldNotify(covariant _ScopeNavigatorProxy oldWidget) {
    return state != oldWidget.state;
  }
}

class _Layer {
  _Layer(this.route, this.secondaryAnimation, this.completer, this.hero);

  final ScopePageRoute route;
  final AnimationController secondaryAnimation;
  final Completer completer;
  final _ScopeHeroState hero;
  final ValueNotifier<bool> _isPopped = ValueNotifier(false);
  bool get pushed {
    return !_isPopped.value;
  }

  void initState() {
    if (hero != null) {
      hero.updateRegion();
      hero.hide();
    }
  }

  void dispose() async {
    if (hero != null && hero.mounted) hero.show();
    if (!completer.isCompleted) completer.complete();
  }

  Widget build({SpringDescription spring, Region region}) {
    return _RouteLayer(
      layer: this,
      spring: spring,
      region: region,
      hero: hero,
    );
  }
}

class _RemoveLayerNotification extends Notification {
  final _Layer layer;
  _RemoveLayerNotification({@required this.layer});
}

class _RouteLayer extends StatefulWidget {
  _RouteLayer({
    @required this.layer,
    @required this.spring,
    @required this.region,
    @required this.hero,
  }) : super(key: ValueKey(layer));

  final _Layer layer;
  final _ScopeHeroState hero;
  final Region region;
  final SpringDescription spring;

  @override
  _RouteLayerState createState() => _RouteLayerState();
}

class _RouteLayerState extends State<_RouteLayer>
    with SingleTickerProviderStateMixin<_RouteLayer> {
  static Widget _layoutBuilder(
      Widget currentChild, List<Widget> previousChildren) {
    return Stack(
      children: [...previousChildren, currentChild],
      alignment: Alignment.centerLeft,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
    );
  }

  AnimationController _controller;
  LocalHistoryEntry _historyEntry;
  Function() _onRemoved;
  TapGestureRecognizer _recognizer;
  bool _disposed;

  _Layer get _layer {
    return widget.layer;
  }

  AnimationController get _secondaryAnimation {
    return _layer.secondaryAnimation;
  }

  bool get _isPopped {
    return _layer._isPopped.value;
  }

  set _isPopped(bool value) {
    _layer._isPopped.value = value;
  }

  @override
  void initState() {
    super.initState();
    _recognizer = TapGestureRecognizer(debugOwner: this)..onTap = _onTap;
    _controller = AnimationController(vsync: this)
      ..addStatusListener(_animationStatusChanged);
    _disposed = false;
    _isPopped = false;

    if (_secondaryAnimation != null) _controller.addListener(_syncAnimation);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        await _controller.animationWithSpring(widget.spring, 1);
        if (_layer.hero != null)
          _controller.addListener(_layer.hero.updateRegion);
      }
    });
  }

  @override
  void didUpdateWidget(_RouteLayer oldWidget) {
    assert(_layer == oldWidget.layer);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _disposed = true;
    _layer._isPopped.dispose();
    _controller.dispose();
    _recognizer.dispose();
    _historyEntry?.remove();
    super.dispose();
  }

  void _syncAnimation() {
    _secondaryAnimation.value = _controller.value;
  }

  void _animationStatusChanged(AnimationStatus status) {
    removeRoute() {
      // animation already running, avoid run animation again
      _onRemoved = () {};
      _historyEntry?.remove();
    }

    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        if (_isPopped == false)
          _ensureHistoryEntry();
        else
          removeRoute();
        break;

      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        if (1.0 - _controller.value < 0.001)
          _ensureHistoryEntry();
        else {
          assert(_controller.value - 0.0 < 0.001);
          _historyEntry?.remove();
          _historyEntry = null;
          _RemoveLayerNotification(layer: _layer).dispatch(context);
        }
        break;
    }
  }

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute route = ModalRoute.of(context);
      if (route != null) {
        setState(() {
          _isPopped = false;
          _onRemoved = () => _controller.animationWithSpring(widget.spring, 0);
          _historyEntry =
              LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
          route.addLocalHistoryEntry(_historyEntry);
        });
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    if (_disposed) return;
    _historyEntry = null;
    setState(() {
      _isPopped = true;
      _onRemoved();
    });
  }

  void _onTap() {
    if (_isPopped == true)
      setState(() {
        _ensureHistoryEntry();
        _controller.animationWithSpring(widget.spring, 1);
      });
  }

  void _onPointerDown(PointerDownEvent event) {
    if (mounted) _recognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _ScopePageRoute(
        state: this,
        child: _PrimaryAnimationController(
          controller: _controller,
          child: _RouteStatus(
            isPopped: _isPopped,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Builder(
                  builder: (context) {
                    return _layer.route.backgroundBuilder(
                        context, _controller, _secondaryAnimation);
                  },
                ),
                ValueListenableBuilder<Region>(
                  valueListenable: widget.hero?.region ??
                      AlwaysStoppedAnimation(widget.region),
                  builder: (BuildContext context, Region value, Widget child) {
                    return AnimatedRegionPositioned(
                        animation: Tween(begin: value, end: widget.region)
                            .animate(_controller),
                        child: child);
                  },
                  child: Listener(
                    onPointerDown: _onPointerDown,
                    child: AnimationControllerBuilder(builder: _builder),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(
      BuildContext context, AnimationController controller, Widget child) {
    final builder = _layer.route.builder;
    return _SecondaryAnimationController(
      controller: controller,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        layoutBuilder: _layoutBuilder,
        child: builder == null
            ? const SizedBox()
            : KeyedSubtree(
                key: GlobalObjectKey(builder),
                child: builder(context, _controller.view, controller.view),
              ),
      ),
    );
  }
}

class _Navigator extends InheritedWidget {
  const _Navigator({Key key, @required Widget child, @required this.state})
      : super(key: key, child: child);
  final _ScopeNavigatorState state;

  @override
  bool updateShouldNotify(_Navigator oldWidget) {
    return state != oldWidget.state;
  }
}

class _RouteStatus extends InheritedWidget {
  const _RouteStatus({
    Key key,
    @required Widget child,
    @required this.isPopped,
  }) : super(key: key, child: child);

  final bool isPopped;
  bool get isPushed {
    return !isPopped;
  }

  @override
  bool updateShouldNotify(_RouteStatus oldWidget) {
    return oldWidget.isPopped != isPopped;
  }
}

class _PrimaryAnimationController extends InheritedWidget {
  const _PrimaryAnimationController({
    Key key,
    @required Widget child,
    @required this.controller,
  }) : super(key: key, child: child);

  final AnimationController controller;

  @override
  bool updateShouldNotify(_PrimaryAnimationController oldWidget) {
    return oldWidget.controller != controller;
  }
}

class _SecondaryAnimationController extends InheritedWidget {
  const _SecondaryAnimationController({
    Key key,
    @required Widget child,
    @required this.controller,
  }) : super(key: key, child: child);

  final AnimationController controller;

  @override
  bool updateShouldNotify(_SecondaryAnimationController oldWidget) {
    return oldWidget.controller != controller;
  }
}

class ScopeHero extends StatefulWidget {
  static RegionObserverMixin of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_HeroRegionObserver>()
        ?.state;
  }

  const ScopeHero({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _ScopeHeroState createState() => _ScopeHeroState();
}

class _ScopeHeroState extends State<ScopeHero>
    with RegionObserverMixin<ScopeHero> {
  @override
  ValueNotifier<bool> visibility;
  @override
  ValueNotifier<Region> region;

  @override
  void initState() {
    super.initState();
    visibility = ValueNotifier(true);
    region = ValueNotifier(null);
  }

  @override
  void dispose() {
    region.dispose();
    visibility.dispose();
    super.dispose();
  }

  bool _onNotification(SizeChangedLayoutNotification notification) {
    WidgetsBinding.instance.addPostFrameCallback(_onSizeChanged);
    return true;
  }

  void _onSizeChanged([timeStamp]) {
    if (mounted) updateRegion();
  }

  bool canPushFromThis() {
    // whether the route beyond this route can push with hero animation
    if (!mounted) return false;
    final status = context.dependOnInheritedWidgetOfExactType<_RouteStatus>();
    return status?.isPopped == false; // only the route have not popped
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: _onNotification,
      child: _HeroRegionObserver(
        state: this,
        child: SizeChangedLayoutNotifier(
          child: ValueListenableBuilder<bool>(
            valueListenable: visibility,
            builder: (context, value, child) {
              return Visibility(
                visible: value,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: child,
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _HeroRegionObserver extends InheritedWidget {
  const _HeroRegionObserver({Key key, Widget child, this.state})
      : super(key: key, child: child);

  final _ScopeHeroState state;

  @override
  bool updateShouldNotify(_HeroRegionObserver oldWidget) {
    return state != oldWidget.state;
  }
}
