import 'package:flutter/material.dart';
import 'package:my_web/core/services/spring_provide_service.dart';
import 'package:my_web/ui/.lib.dart';
import 'package:my_web/core/.lib.dart';

void main() {
  return runApp(const MainActivity());
}

class MainActivity extends StatelessWidget {
  const MainActivity({Key key}) : super(key: key);

  static Locale _localeResolutionCallback(
      Locale locale, Iterable<Locale> supportedLocales) {
    // Check if the current device locale is supported
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode ||
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (English, in this case).
    return supportedLocales.first;
  }

  @override
  Widget build(BuildContext context) {
    return SpringProvideService(
      child: LocaleService(
        builder: (context, locale) {
          return ThemeService(
            builder: (context, theme) {
              return MaterialApp(
                title: 'My Web',
                theme: theme,
                locale: locale,
                supportedLocales: LocaleService.supportedLocales,
                localeResolutionCallback: _localeResolutionCallback,
                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  StandardLocalizationsDelegate(locale),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                home: const HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
