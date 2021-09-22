import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/core/services/storage_service.dart';

typedef ThemeServiceBuilder = Widget Function(
    BuildContext context, ThemeData theme);

class ThemeService extends StatefulWidget {
  static _ThemeService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ThemeService>()!;
  }

  static const _shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)));
  static const _cardTheme = CardTheme(shape: _shape);

  static final lightTheme = ThemeData(
    cardTheme: _cardTheme,
    selectedRowColor: Colors.black12,
    toggleableActiveColor: Colors.cyanAccent,
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardTheme: _cardTheme,
  );
  static final List<ThemeData> supportedThemes = [lightTheme, darkTheme];

  const ThemeService(
      {Key? key,
      required this.builder,
      this.expandedHeight = 120,
      this.bottomSheetPadding = const EdgeInsets.all(8.0)})
      : super(key: key);
  final ThemeServiceBuilder builder;
  final double expandedHeight;
  final EdgeInsets bottomSheetPadding;

  @override
  _ThemeServiceState createState() => _ThemeServiceState();
}

class _ThemeServiceState extends State<ThemeService> {
  static const _darkModeKey = 'ThemeService#DarkMode';

  late ThemeData _cache;
  ThemeData get _theme {
    return _cache;
  }

  set _theme(ThemeData theme) {
    final service = LocaleService.of(context);
    _cache = ThemeData(
      cardTheme: theme.cardTheme,
      selectedRowColor: theme.selectedRowColor,
      toggleableActiveColor: theme.toggleableActiveColor,
      brightness: theme.brightness,
      fontFamily: service.fontFamily,
    );
  }

  _changeTheme(ThemeData theme) async {
    assert(ThemeService.supportedThemes.contains(theme));
    final storage = StorageService.of(context);
    await storage.setBool(_darkModeKey, theme.brightness == Brightness.dark);
    if (mounted) setState(() => _theme = theme);
  }

  @override
  void didChangeDependencies() {
    final storage = StorageService.of(context);
    try {
      final isDark = storage.getBool(_darkModeKey) ?? false;
      _theme = isDark ? ThemeService.darkTheme : ThemeService.lightTheme;
    } catch (error) {
      print(error);
    }
    super.didChangeDependencies();
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
  const _ThemeService({Key? key, required Widget child, required this.state})
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

  EdgeInsets get bottomSheetPadding {
    return state.widget.bottomSheetPadding;
  }

  TextStyle get textButtonStyle {
    return TextStyle(color: state._theme.toggleableActiveColor);
  }

  TextTheme get textTheme {
    return theme.textTheme;
  }

  IconThemeData get appBarIconTheme {
    return theme.appBarTheme.iconTheme ?? theme.primaryIconTheme;
  }

  TextStyle get centerStyle {
    return theme.appBarTheme.titleTextStyle ??
        theme.primaryTextTheme.headline6!;
  }

  TextStyle get sideStyle {
    return theme.appBarTheme.toolbarTextStyle ??
        theme.primaryTextTheme.bodyText2!;
  }

  @override
  bool updateShouldNotify(covariant _ThemeService oldWidget) {
    return state != oldWidget.state;
  }
}
