import 'dart:math';

import 'package:flutter/material.dart';

typedef Widget GroupAnimationBuilder(
    BuildContext context, Animation<double> animation, Widget child);

typedef Animation<double> ExtractAnimation(State state);

class GroupAnimationService extends StatefulWidget {
  /// provider a host to drive all [GroupAnimationService.client] in the sub tree

  static Widget activeHost({
    Key key,
    @required Widget child,
    @required Duration duration,
    Future delay,
    Curve curve,
  }) {
    return _GroupAnimationActiveHost(
      key: key,
      child: child,
      duration: duration,
      curve: curve ?? Curves.linear,
    );
  }

  static Widget passiveHost({
    Key key,
    @required Widget child,
    @required Animation<double> animation,
    Curve curve,
  }) {
    return _GroupAnimationPassiveHost(
      key: key,
      child: child,
      animation: animation,
      curve: curve ?? Curves.linear,
    );
  }

  /// provider a host to drive all [GroupAnimationService.client] in the sub tree
  static Widget customHost({
    @required Widget child,
    final ExtractAnimation
        extract, // group animation provider extract the animation
    final Function(State state)
        registered, // notify parent the sub tree initState
    final Function(State state)
        unregistered, // notify parent the sub tree was disposed
  }) {
    return _InheritedGroupAnimationHost(
      child: child,
      extract: extract,
      registered: registered,
      unregistered: unregistered,
    );
  }

  const GroupAnimationService.client(
      {Key key, @required this.builder, this.child})
      : super(key: key);
  final GroupAnimationBuilder builder;
  final Widget child;

  @override
  _GroupAnimationServiceState createState() => _GroupAnimationServiceState();
}

class _GroupAnimationServiceState extends State<GroupAnimationService> {
  _InheritedGroupAnimationHost _host;
  Animation<double> _animation;

  @override
  void didChangeDependencies() {
    final host = _InheritedGroupAnimationHost.of(context);
    assert(host != null,
        'GroupAnimationProvider.client must wrap in one GroupAnimationProvider.host at least. ');
    if (_host != host) {
      _host?.unregistered(this);
      _host = host;
      _host.registered(this);
      _animation = _host.extract(this);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _host?.unregistered(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _animation,
      widget.child,
    );
  }
}

class _GroupAnimationActiveHost extends StatefulWidget {
  const _GroupAnimationActiveHost({
    Key key,
    @required this.child,
    @required this.duration,
    @required this.curve,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  _GroupAnimationActiveHostState createState() =>
      _GroupAnimationActiveHostState();
}

class _GroupAnimationActiveHostState extends State<_GroupAnimationActiveHost>
    with SingleTickerProviderStateMixin<_GroupAnimationActiveHost> {
  AnimationController _controller;
  Set<State> _children;

  @override
  void initState() {
    super.initState();
    _children = Set<State>();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..animateTo(1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _children = null;
    super.dispose();
  }

  Animation<double> _extract(State state) {
    final index = _children.toList(growable: false).indexOf(state);
    final begin = min(0.135 * sqrt(index), 1.0);
    final end = 0.5 + 0.5 * begin;
    assert(begin <= end,
        'Begin[$begin] is smaller than End[$end] in index[$index]');
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedGroupAnimationHost(
      child: widget.child,
      extract: _extract,
      registered: (state) {
        _children.add(state);
      },
      unregistered: (state) {
        _children.remove(state);
      },
    );
  }
}

class _GroupAnimationPassiveHost extends StatefulWidget {
  const _GroupAnimationPassiveHost({
    Key key,
    @required this.child,
    @required this.animation,
    @required this.curve,
  }) : super(key: key);

  final Widget child;
  final Animation<double> animation;
  final Curve curve;

  @override
  _GroupAnimationPassiveHostState createState() =>
      _GroupAnimationPassiveHostState();
}

class _GroupAnimationPassiveHostState extends State<_GroupAnimationPassiveHost>
    with SingleTickerProviderStateMixin<_GroupAnimationPassiveHost> {
  Set<State> _children;

  @override
  void initState() {
    super.initState();
    _children = Set<State>();
  }

  @override
  void dispose() {
    _children = null;
    super.dispose();
  }

  Animation<double> _extract(State state) {
    final index = _children.toList(growable: false).indexOf(state);
    final begin = min(0.135 * sqrt(index), 1.0);
    final end = 0.5 + 0.5 * begin;
    assert(begin <= end,
        'Begin[$begin] is smaller than End[$end] in index[$index]');
    return CurvedAnimation(
      parent: widget.animation,
      curve: Interval(begin, end),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedGroupAnimationHost(
      child: widget.child,
      extract: _extract,
      registered: (state) {
        _children.add(state);
      },
      unregistered: (state) {
        _children.remove(state);
      },
    );
  }
}

class _InheritedGroupAnimationHost extends InheritedWidget {
  static _InheritedGroupAnimationHost of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedGroupAnimationHost>();
  }

  const _InheritedGroupAnimationHost({
    Key key,
    @required Widget child,
    @required this.registered,
    @required this.unregistered,
    @required this.extract,
  }) : super(key: key, child: child);

  final ExtractAnimation extract;
  final Function(State state) registered;
  final Function(State state) unregistered;

  @override
  bool updateShouldNotify(_InheritedGroupAnimationHost oldWidget) {
    return extract != oldWidget.extract;
  }
}
