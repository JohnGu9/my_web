import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:my_web/core/.lib.dart';
import 'package:my_web/ui/.lib.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spring = SpringProvideService.of(context);
    final themeService = ThemeService.of(context);
    return ScopeNavigator(
      spring: spring,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: theme.iconTheme,
              textTheme: theme.textTheme,
              backgroundColor: theme.canvasColor,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) navigator.pop();
                },
              ),
              expandedHeight: themeService.expandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  StandardLocalizations.of(context).settings,
                  style: theme.textTheme.headline6,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _ThemeEditTile()),
            const SliverToBoxAdapter(child: _LocaleEditTile()),
            const SliverToBoxAdapter(child: _AboutTile()),
          ],
        ),
      ),
    );
  }
}

class _ThemeEditTile extends StatelessWidget {
  const _ThemeEditTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.brightness_4),
      title: Text(StandardLocalizations.of(context).darkTheme),
      trailing: PlatformSwitch(
        value: theme.brightness == Brightness.dark,
        onChanged: (value) {
          final service = ThemeService.of(context);
          return service.changeTheme(
            value ? ThemeService.darkTheme : ThemeService.lightTheme,
          );
        },
      ),
    );
  }
}

const _titles = {
  'en': 'English',
  'zh': '中文',
};

class _LocaleEditTile extends StatelessWidget {
  const _LocaleEditTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = LocaleService.of(context).locale;
    return ListTile(
      leading: const Icon(Icons.translate),
      title: Text(StandardLocalizations.of(context).language),
      subtitle: Text(current == null
          ? StandardLocalizations.of(context).auto
          : _titles[current.languageCode]),
      onTap: () {
        return ScopeNavigator.of(context).push(ScopePageRoute(
          builder: (context, animation, secondaryAnimation, size) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(animation),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: const _LocaleBottomSheet(),
              ),
            );
          },
        ));
      },
    );
  }
}

class _LocaleBottomSheet extends StatelessWidget {
  const _LocaleBottomSheet({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final current = LocaleService.of(context).locale;
    final themeService = ThemeService.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          margin: themeService.bottomSheetPadding,
          child: Column(
            children: [
              AppBar(
                textTheme: Theme.of(context).textTheme,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                title: Text(StandardLocalizations.of(context).language),
                elevation: 0.0,
              ),
              ListTile(
                title: Text(StandardLocalizations.of(context).auto),
                trailing: Radio<Locale>(
                  value: null,
                  groupValue: current,
                  onChanged: (value) {
                    if (current == null) return;
                    return showChangeLocaleDialog(context, null);
                  },
                ),
                onTap: () {
                  if (current == null) return;
                  return showChangeLocaleDialog(context, null);
                },
              ),
              for (final locale in LocaleService.supportedLocales)
                ListTile(
                  title: Text(_titles[locale.languageCode]),
                  subtitle: Text(locale.languageCode),
                  trailing: Radio<Locale>(
                    value: locale,
                    groupValue: current,
                    onChanged: (value) {
                      if (current == locale) return;
                      return showChangeLocaleDialog(context, locale);
                    },
                  ),
                  onTap: () {
                    if (current == locale) return;
                    return showChangeLocaleDialog(context, locale);
                  },
                ),
            ],
          ),
        ),
        Card(
          margin: themeService.bottomSheetPadding.copyWith(top: 0.0),
          child: InkWell(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  StandardLocalizations.of(context).cancel,
                  style: themeService.textButtonStyle,
                ),
              ),
            ),
            onTap: () {
              return Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(StandardLocalizations.of(context).about),
      subtitle: Text(Constants.version),
      onTap: () {
        return ScopeNavigator.of(context).push(ScopePageRoute(
          builder: (context, animation, secondaryAnimation, size) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(animation),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: const _AboutBottomSheet(),
              ),
            );
          },
        ));
      },
    );
  }
}

class _AboutBottomSheet extends StatelessWidget {
  const _AboutBottomSheet({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final themeService = ThemeService.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          margin: themeService.bottomSheetPadding,
          child: Column(
            children: [
              AppBar(
                textTheme: Theme.of(context).textTheme,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                title: Text(localization.about),
                elevation: 0.0,
              ),
              ListTile(
                title: Text(localization.version),
                trailing: Text(Constants.version),
              ),
              Tooltip(
                message: localization.visit,
                child: ListTile(
                  title: Text(localization.framework),
                  trailing: const FlutterLogo(),
                  onTap: () {
                    const url = 'https://flutter.dev';
                    return showVisitWebsiteDialog(context, url);
                  },
                ),
              ),
              ListTile(
                title: Text(localization.distTechnique),
                trailing: const SizedBox(
                    width: 32, child: const Image(image: Constants.pwaImage)),
              ),
              Tooltip(
                message: localization.visit,
                child: ListTile(
                  title: Text(localization.source),
                  trailing:
                      const SelectableText('https://github.com/JohnGu9/my_web'),
                  onTap: () {
                    const url = 'https://github.com/JohnGu9/my_web';
                    return showVisitWebsiteDialog(context, url);
                  },
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: themeService.bottomSheetPadding.copyWith(top: 0.0),
          child: InkWell(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localization.cancel,
                  style: themeService.textButtonStyle,
                ),
              ),
            ),
            onTap: () {
              return Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
