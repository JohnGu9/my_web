import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:my_web/core/core.dart';

import 'package:my_web/ui/widgets/widgets.dart';
import 'package:my_web/ui/dialogs/dialogs.dart';

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

class _LocaleEditTile extends StatelessWidget {
  const _LocaleEditTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titles = {
      'en': const Text('English'),
      'zh': theme.brightness == Brightness.dark
          ? const Image(
              image: Constants.zhWitheImage,
              alignment: Alignment.centerLeft,
              height: 21,
            )
          : const Image(
              image: Constants.zhBlackImage,
              alignment: Alignment.centerLeft,
              height: 21,
            ),
    };
    final current = LocaleService.of(context).locale;
    return ListTile(
      leading: const Icon(Icons.translate),
      title: Text(StandardLocalizations.of(context).language),
      subtitle: current == null
          ? Text(StandardLocalizations.of(context).auto)
          : titles[current.languageCode],
      onTap: () {
        return ScopeNavigator.of(context).push(ScopePageRoute(
          builder: (context, animation, secondaryAnimation) {
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
          clipBehavior: Clip.hardEdge,
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
                _Tile(locale: locale),
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

class _Tile extends StatefulWidget {
  const _Tile({Key key, this.locale}) : super(key: key);

  final Locale locale;

  @override
  __TileState createState() => __TileState();
}

class __TileState extends State<_Tile>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  Locale get _current {
    return LocaleService.of(context).locale;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    final service = LocaleService.of(context);
    final status = service.checkLoadingFont(widget.locale);
    if (status is Future<bool>) {
      _controller.value = 1.0;
      () async {
        final load = await status;
        if (!mounted) return;
        _controller.animateWith(SpringSimulation(
            spring, _controller.value, 0.0, _controller.velocity));
        if (!load) return showAlertDialog(context, 'Load font failed. ');
      }();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onTap([value]) async {
    if (!mounted) return;
    final service = LocaleService.of(context);
    if (service.locale == widget.locale) return;
    dynamic load = service.loadFont(widget.locale);
    if (load is Future<bool>) {
      _controller.animateWith(SpringSimulation(
          spring, _controller.value, 1.0, _controller.velocity));
      load = await load;
      if (!mounted) return;
      _controller.animateWith(SpringSimulation(
          spring, _controller.value, 0.0, _controller.velocity));
    }
    if (!load) return showAlertDialog(context, 'Load font failed. ');
    return showChangeLocaleDialog(context, widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTween = ColorTween(
        begin: theme.selectedRowColor.withOpacity(0.0),
        end: theme.selectedRowColor.withOpacity(0.12));
    final titles = {
      'en': const Text('English'),
      'zh': theme.brightness == Brightness.dark
          ? const Image(
              image: Constants.zhWitheImage,
              alignment: Alignment.centerLeft,
              height: 21,
            )
          : const Image(
              image: Constants.zhBlackImage,
              alignment: Alignment.centerLeft,
              height: 21,
            ),
    };
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          child: child,
          color: colorTween.evaluate(_controller),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: titles[widget.locale.languageCode],
            subtitle: Text(widget.locale.languageCode),
            trailing: Radio<Locale>(
              value: widget.locale,
              groupValue: _current,
              onChanged: _onTap,
            ),
            onTap: _onTap,
          ),
          FadeTransition(
            opacity: _controller,
            child: SizeTransition(
              axis: Axis.vertical,
              sizeFactor: _controller,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return TickerMode(
                    enabled: _controller.value != _controller.lowerBound,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 16.0),
                      child: Text(
                        'Downloading necessary font...\nDuration depend on your network (zh and jp need more time)',
                        style: theme.textTheme.caption,
                      ),
                    ),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          builder: (context, animation, secondaryAnimation) {
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
