import 'package:flutter/material.dart';

class SimpleShortcuts extends StatelessWidget {
  const SimpleShortcuts(
      {super.key, required this.child, required this.shortcuts});
  static final _actions = {_ActionIntent: _Action()};

  final Widget child;
  final Map<ShortcutActivator, void Function()> shortcuts;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: shortcuts.map(
        (key, value) => MapEntry(key, _ActionIntent(value)),
      ),
      child: Actions(
        actions: _actions,
        child: child,
      ),
    );
  }
}

class _ActionIntent extends Intent {
  const _ActionIntent(this.fn);
  final void Function() fn;
}

class _Action extends Action<_ActionIntent> {
  factory _Action() {
    return _i;
  }
  _Action._internal();
  static final _i = _Action._internal();

  @override
  void invoke(covariant _ActionIntent intent) => intent.fn();
}
