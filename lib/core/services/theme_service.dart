import 'package:flutter/material.dart';

typedef ThemeServiceBuilder = Widget Function(
    BuildContext context, ThemeData theme);

class ThemeService extends StatefulWidget {
  static _ThemeService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ThemeService>();
  }

  static const _shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)));
  static const _cardTheme = CardTheme(shape: _shape);

  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    cardTheme: _cardTheme,
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardTheme: _cardTheme,
  );
  static final List<ThemeData> supportedThemes = [lightTheme, darkTheme];

  const ThemeService(
      {Key key,
      this.builder,
      this.expandedHeight = 120,
      this.bottomSheetPadding = const EdgeInsets.all(8.0)})
      : super(key: key);
  final ThemeServiceBuilder builder;
  final double expandedHeight;
  final EdgeInsetsGeometry bottomSheetPadding;

  @override
  _ThemeServiceState createState() => _ThemeServiceState();
}

class _ThemeServiceState extends State<ThemeService> {
  ThemeData _theme = ThemeService.supportedThemes.last;

  _changeTheme(ThemeData theme) {
    assert(ThemeService.supportedThemes.contains(theme));
    return setState(() {
      return _theme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeService(
      state: this,
      child: widget.builder(context, _theme),
    );
  }
}

class _ThemeService extends InheritedWidget {
  const _ThemeService({Key key, Widget child, this.state})
      : super(key: key, child: child);

  @visibleForTesting
  final _ThemeServiceState state;

  ThemeData get theme {
    return state._theme;
  }

  changeTheme(ThemeData theme) {
    return state._changeTheme(theme);
  }

  double get expandedHeight {
    return state.widget.expandedHeight;
  }

  EdgeInsetsGeometry get bottomSheetPadding {
    return state.widget.bottomSheetPadding;
  }

  TextStyle get textButtonStyle {
    return TextStyle(color: state._theme.toggleableActiveColor);
  }

  @override
  bool updateShouldNotify(covariant _ThemeService oldWidget) {
    return state != oldWidget.state;
  }
}
