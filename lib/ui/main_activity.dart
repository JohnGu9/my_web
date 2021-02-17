import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_web/core/native/native_channel.dart';

import 'layout_desktop/layout_desktop.dart' as desktop;
import 'layout_mobile/layout_mobile.dart' as mobile;

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with SingleTickerProviderStateMixin<MainActivity> {
  static Locale _localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode ||
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  late Future _init;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init = () async {
      await Future.wait([
        precacheImage(Constants.personLogoImage, context),
        precacheImage(Constants.githubLogoImage, context),
        precacheImage(Constants.mediumLogoImage, context),
        precacheImage(Constants.mailLogoImage, context),
        precacheImage(Constants.backgroundImage, context),
        precacheImage(Constants.otherImage, context),
        precacheImage(Constants.skillImage, context),
      ]);

      /// no need to check [mounted]. If state is not mounted, the app don't run at all.
      _controller.animateTo(1.0, duration: const Duration(milliseconds: 700));
    }();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NativeChannel(
      child: StorageService(
        child: PlatformService(
          child: SpringProvideService(
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
                            child: const PlatformHomePage(),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformHomePage extends StatelessWidget {
  const PlatformHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformService.of(context).isMobile;
    return isMobile ? const mobile.HomePage() : const desktop.HomePage();
  }
}
