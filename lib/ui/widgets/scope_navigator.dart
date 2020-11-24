import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:listenable_list/listenable_list.dart';

import 'package:my_web/core/.lib.dart';
import 'package:my_web/ui/.lib.dart';

typedef Widget ScopePageRouteBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Size size);

typedef Widget ScopePageRouteBackgroundBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Region region);

typedef Widget _SecondaryAnimationBuilder(
  BuildContext context,
  bool noRouteLayer,
  Widget child,
);

class ScopePageRoute {
  static Widget _backgroundBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Region region) {
    final color = ColorTween(begin: Colors.transparent, end: Colors.black38)
        .animate(animation);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: color,
        builder: (context, child) {
          return Container(color: color.value);
        },
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

class _ScopeNavigator {
  static _ScopeNavigator of(BuildContext context) {
    final navigator = context.dependOnInheritedWidgetOfExactType<_Navigator>();
    final secondaryAnimation = context
        .dependOnInheritedWidgetOfExactType<_SecondaryAnimationController>()
        ?.controller;
    return _ScopeNavigator._internal(navigator.state, secondaryAnimation);
  }

  _ScopeNavigator._internal(this._state, this._secondaryAnimation);
  final _ScopeNavigatorState _state;
  final AnimationController _secondaryAnimation;

  Future<void> push(ScopePageRoute route) async {
    final newLayer = _Layer(route, _secondaryAnimation, Completer());
    _state._layers.add(newLayer);
    return newLayer.completer.future;
  }
}

class ScopeNavigator extends StatefulWidget {
  static _ScopeNavigator of(BuildContext context) {
    return _ScopeNavigator.of(context);
  }

  static Widget _builder(
    BuildContext context,
    bool available,
    Widget child,
  ) {
    return IgnorePointer(
      ignoring: !available,
      child: child,
    );
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
  void dispose() {
    _layers.forEach((element) => element.dispose());
    _layers.dispose();
    super.dispose();
  }

  void _onLayersChanged() {
    _layers.added.forEach((key, element) {
      element._isPopped.addListener(_onRouteStatusChanged);
    });
  }

  void _onRouteStatusChanged() {
    setState(() {});
  }

  bool _onRemoveLayerNotification(_RemoveLayerNotification notification) {
    final layer = notification.layer;
    layer.completer.complete();
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
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );
    return ValueListenableBuilder<List<_Layer>>(
      valueListenable: _layers,
      builder: (context, value, child) {
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            widget.builder(
              context,
              _layers.every((element) => element._isPopped.value),
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

class _Layer {
  _Layer(
    this.route,
    this.secondaryAnimation,
    this.completer,
  );

  final ScopePageRoute route;
  final AnimationController secondaryAnimation;
  final Completer completer;

  final ValueNotifier<bool> _isPopped = ValueNotifier(false);
  void dispose() {
    if (!completer.isCompleted) completer.complete();
  }

  Widget build({SpringDescription spring, Region region}) {
    return _RouteLayer(
      layer: this,
      spring: spring,
      region: region,
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
  }) : super(key: ValueKey(layer));

  final _Layer layer;
  final Region region;
  final SpringDescription spring;

  @override
  _RouteLayerState createState() => _RouteLayerState();
}

class _RouteLayerState extends State<_RouteLayer>
    with SingleTickerProviderStateMixin<_RouteLayer> {
  static TickerFuture _animateWith(
      AnimationController controller, double value, SpringDescription spring) {
    final res = controller.animateWith(
        SpringSimulation(spring, controller.value, value, controller.velocity));
    return res;
  }

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) _animateWith(_controller, 1, widget.spring);
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

  void _onTap() {
    setState(() {
      _ensureHistoryEntry();
      _animateWith(_controller, 1, widget.spring);
    });
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
          _onRemoved = () => _animateWith(_controller, 0, widget.spring);
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

  void _onPointerDown(PointerDownEvent event) {
    if (mounted) _recognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _PrimaryAnimationController(
        controller: _controller,
        child: _RouteStatus(
          isPopped: _isPopped,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _layer.route.backgroundBuilder(
                context,
                _controller,
                _secondaryAnimation,
                widget.region,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _layer._isPopped,
                builder: _rePushGestureBuilder,
                child: AnimationControllerBuilder(builder: _builder),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rePushGestureBuilder(BuildContext context, bool value, Widget child) {
    return Listener(
      onPointerDown: value ? _onPointerDown : null,
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(ignoring: value, child: child),
    );
  }

  Widget _builder(
    BuildContext context,
    AnimationController controller,
    Widget child,
  ) {
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
                child: builder(
                  context,
                  _controller.view,
                  controller.view,
                  widget.region.size,
                ),
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
        .dependOnInheritedWidgetOfExactType<_HeroRegionObserverBinding>()
        .observer;
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
      child: _HeroRegionObserverBinding(
        observer: this,
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
          child: SizeChangedLayoutNotifier(child: widget.child),
        ),
      ),
    );
  }
}

class _HeroRegionObserverBinding extends InheritedWidget {
  const _HeroRegionObserverBinding({Key key, Widget child, this.observer})
      : super(key: key, child: child);

  final _ScopeHeroState observer;

  @override
  bool updateShouldNotify(_HeroRegionObserverBinding oldWidget) {
    return observer != oldWidget.observer;
  }
}
