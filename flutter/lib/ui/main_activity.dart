import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_web/core/native/native_channel.dart';
import 'package:my_web/ui/widgets/page_route_animation.dart';

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
                      title: "JohnGu's Profile",
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
                      home: _DelayRoute(
                          future: Future.wait([
                        precacheImage(Constants.personLogoImage, context),
                        // precacheImage(Constants.githubLogoImage, context),
                        // precacheImage(Constants.mediumLogoImage, context),
                        // precacheImage(Constants.mailLogoImage, context),
                        // precacheImage(Constants.backgroundImage, context),
                        // precacheImage(Constants.otherImage, context),
                        // precacheImage(Constants.skillImage, context),
                      ])),
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

class _DelayRoute extends StatefulWidget {
  final Future future;

  const _DelayRoute({Key? key, required this.future}) : super(key: key);

  @override
  State<_DelayRoute> createState() => _DelayRouteState();
}

class _DelayRouteState extends State<_DelayRoute> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.future.then((value) {
      if (mounted)
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 3),
            pageBuilder: (context, animation, secondaryAnimation) {
              final curvedAnimation = CurvedAnimation(
                  parent: animation, curve: const Interval(0.2, 1));
              return Material(
                child: ScaleTransition(
                  scale:
                      Tween(begin: 1.0, end: 0.95).animate(secondaryAnimation),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                        parent: curvedAnimation, curve: Curves.fastOutSlowIn),
                    child: PageRouteAnimation(
                      animation: curvedAnimation,
                      secondaryAnimation: secondaryAnimation,
                      child: const PlatformHomePage(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class PlatformHomePage extends StatelessWidget {
  const PlatformHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformService.of(context).isMobile;
    return false ? const mobile.HomePage() : const desktop.HomePage();
  }
}
