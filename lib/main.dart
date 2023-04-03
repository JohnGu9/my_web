import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'core/data/localizations_delegates.dart';
import 'core/provider/custom_theme_provider.dart';
import 'core/provider/settings_provider.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsProvider(
      child: CustomThemeProvider(
        child: _Builder(),
      ),
    );
  }
}

class _Builder extends StatelessWidget {
  const _Builder();

  @override
  Widget build(BuildContext context) {
    final customTheme = CustomTheme.of(context).customTheme;
    if (Settings.initiating(context) == true) {
      return const SizedBox();
    }
    return MaterialApp(
      title: "My Website",
      scrollBehavior: const _MyCustomScrollBehavior(),
      theme: FlexColorScheme.light(useMaterial3: true, fontFamily: "Roboto")
          .toTheme,
      darkTheme: FlexColorScheme.dark(useMaterial3: true, fontFamily: "Roboto")
          .toTheme,
      themeMode: ThemeMode.dark, // TODO: light mode
      locale: customTheme?.locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  const _MyCustomScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...PointerDeviceKind.values,
      };
}
