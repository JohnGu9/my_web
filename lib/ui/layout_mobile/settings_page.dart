import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'package:my_web/core/core.dart';
import 'package:my_web/ui/dialogs/dialogs.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        AppBar(
          textTheme: theme.textTheme,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(localizations.settings),
        ),
        SwitchListTile.adaptive(
          secondary: const Icon(Icons.brightness_4),
          title: Text(localizations.darkTheme),
          onChanged: (bool value) {
            final service = ThemeService.of(context);
            return service.changeTheme(
              value ? ThemeService.darkTheme : ThemeService.lightTheme,
            );
          },
          value: theme.brightness == Brightness.dark,
        ),
        const Divider(),
        const _LocaleBottomSheet(),
        const Divider(),
        const _About(),
      ],
    );
  }
}

class _LocaleBottomSheet extends StatelessWidget {
  const _LocaleBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = LocaleService.of(context).locale;
    final localizations = StandardLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          textTheme: Theme.of(context).textTheme,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(localizations.language),
          elevation: 0.0,
        ),
        ListTile(
          title: Text(localizations.auto),
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

class _About extends StatelessWidget {
  const _About({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    return Column(
      children: [
        AppBar(
          textTheme: Theme.of(context).textTheme,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(localizations.about),
          elevation: 0.0,
        ),
        ListTile(
          title: Text(
            localizations.version,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(Constants.version),
        ),
        Tooltip(
          message: localizations.visit,
          child: ListTile(
            title: Text(
              localizations.source,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const SelectableText('https://github.com/JohnGu9/my_web',
                maxLines: 1),
            onTap: () {
              const url = 'https://github.com/JohnGu9/my_web';
              showVisitWebsiteDialog(context, url);
            },
          ),
        ),
      ],
    );
  }
}
