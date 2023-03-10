import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_web/core/data/assets.dart';

import 'ui/home_page.dart';
import 'core/provider/custom_theme_provider.dart';
import 'core/provider/settings_provider.dart';

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
  static Future? _cache;
  const _Builder();

  @override
  Widget build(BuildContext context) {
    final customTheme = CustomTheme.of(context).customTheme;
    return FutureBuilder(
        future: _cache ??= precacheImage(Assets.background, context),
        builder: (context, snapshot) {
          if (Settings.initiating(context) == true ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return MaterialApp(
            scrollBehavior: const _MyCustomScrollBehavior(),
            theme: FlexColorScheme.light(useMaterial3: true).toTheme,
            darkTheme: FlexColorScheme.dark(useMaterial3: true).toTheme,
            themeMode: ThemeMode.dark, // tODO: light mode
            locale: customTheme?.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("en"),
              Locale("zh"),
            ],
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        });
  }
}

class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  const _MyCustomScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...PointerDeviceKind.values,
      };
}
