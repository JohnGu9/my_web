import 'package:flutter/material.dart';
import 'settings_provider.dart';

class CustomThemeProvider extends StatefulWidget {
  const CustomThemeProvider({super.key, required this.child});

  final Widget child;

  @override
  State<CustomThemeProvider> createState() => _CustomThemeProviderState();
}

class _CustomThemeProviderState extends State<CustomThemeProvider> {
  Settings? _settings;
  CustomThemeData? _customTheme;

  _setCustomTheme(CustomThemeData newCustomTheme) {
    final settings = _settings;
    if (settings != null) {
      setState(() {
        _customTheme = newCustomTheme;
        settings.setValue<bool>(
          r"customTheme-useMaterial3",
          newCustomTheme.useMaterial3,
        );
        switch (newCustomTheme.themeMode) {
          case ThemeMode.light:
            settings.setValue<int>(r"customTheme-themeMode", 0);
            break;
          case ThemeMode.dark:
            settings.setValue<int>(r"customTheme-themeMode", 1);
            break;
          default:
            settings.remove(r"customTheme-themeMode");
        }
        final locale = newCustomTheme.locale;
        if (locale == null) {
          settings.remove(r"customTheme-locale");
        } else {
          settings.setValue(r"customTheme-locale", locale.languageCode);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    final settings = Settings.mayOf(context);
    if (_settings != settings) {
      _settings = settings;
      if (settings != null) {
        final useMaterial3 =
            settings.getValue<bool>(r"customTheme-useMaterial3") ?? true;
        final themeMode = () {
          switch (settings.getValue<int>(r"customTheme-themeMode")) {
            case 0:
              return ThemeMode.light;
            case 1:
              return ThemeMode.dark;
            default:
              return ThemeMode.system;
          }
        }();
        final locale = () {
          final value = settings.getValue<String>(r"customTheme-locale");
          if (value == null) return null;
          return Locale(value);
        }();
        _customTheme = CustomThemeData(useMaterial3, themeMode, locale);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _settings = null;
    _customTheme = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      customTheme: _customTheme,
      setCustomTheme: _setCustomTheme,
      child: widget.child,
    );
  }
}

class CustomTheme extends InheritedWidget {
  const CustomTheme({
    super.key,
    required Widget child,
    required this.customTheme,
    required this.setCustomTheme,
  }) : super(child: child);
  static CustomTheme? mayOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomTheme>();
  }

  static CustomTheme of(BuildContext context) {
    return mayOf(context)!;
  }

  final CustomThemeData? customTheme;
  final Function(CustomThemeData newCustomTheme) setCustomTheme;

  @override
  bool updateShouldNotify(covariant CustomTheme oldWidget) {
    return customTheme != oldWidget.customTheme;
  }
}

class CustomThemeData {
  const CustomThemeData(this.useMaterial3, this.themeMode, this.locale);
  final bool useMaterial3;
  final ThemeMode themeMode;
  final Locale? locale;

  CustomThemeData copyWith({bool? useMaterial3, ThemeMode? themeMode}) {
    return CustomThemeData(
      useMaterial3 ?? this.useMaterial3,
      themeMode ?? this.themeMode,
      locale,
    );
  }

  CustomThemeData copyWithLocal(Locale? locale) {
    return CustomThemeData(
      useMaterial3,
      themeMode,
      locale,
    );
  }
}
