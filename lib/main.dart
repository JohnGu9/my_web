import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_web/ui/.lib.dart';
import 'package:my_web/core/.lib.dart';

void main() {
  return runApp(const MainActivity());
}

class MainActivity extends StatefulWidget {
  const MainActivity({Key key}) : super(key: key);

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with SingleTickerProviderStateMixin<MainActivity> {
  static Locale _localeResolutionCallback(
      Locale locale, Iterable<Locale> supportedLocales) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode ||
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  Future _init;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init = () async {
      await Future.wait([
        precacheImage(Constants.personLogoImage, context),
        precacheImage(Constants.githubLogoImage, context),
        precacheImage(Constants.mailLogoImage, context),
        precacheImage(Constants.pwaImage, context),
        precacheImage(Constants.backgroundImage, context),
        precacheImage(Constants.otherImage, context),
        precacheImage(Constants.skillImage, context),
        precacheImage(Constants.jinanLogoImage, context),
        //
        // precacheImage(Constants.dartLogoImage, context),
        // precacheImage(Constants.tensorflowLogoImage, context),
        // precacheImage(Constants.opencvLogoImage, context),
        // precacheImage(Constants.pythonLogoImage, context),
        // precacheImage(Constants.javaLogoImage, context),
        // precacheImage(Constants.kotlinLogoImage, context),
        // precacheImage(Constants.javascriptLogoImage, context),
        // precacheImage(Constants.cppLogoImage, context),
        // precacheImage(Constants.swiftLogoImage, context),
        // precacheImage(Constants.rustLogoImage, context),
        // precacheImage(Constants.goLogoImage, context),
        // precacheImage(Constants.k8sLogoImage, context),
        // precacheImage(Constants.qtLogoImage, context),
        // precacheImage(Constants.flaskLogoImage, context),
        // precacheImage(Constants.electronLogoImage, context),
        // precacheImage(Constants.nodejsLogoImage, context),
        // precacheImage(Constants.typescriptLogoImage, context),
      ]);
    }()
      ..then((value) async {
        /// no need to check [mounted]. If state is not mounted, the app don't run at all.
        _controller.animateTo(1.0, duration: const Duration(milliseconds: 750));
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                home: FutureBuilder(
                  future: _init,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return const SizedBox();
                    return FadeTransition(
                      opacity: _controller,
                      child: const HomePage(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
