import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef LocaleServiceBuilder = Widget Function(
    BuildContext context, Locale locale);

class LocaleService extends StatefulWidget {
  static _LocaleService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LocaleService>();
  }

  static const en = Locale('en', ''); // English, no country code
  static const zh =
      Locale.fromSubtags(languageCode: 'zh'); // Chinese, no country code
  static const List<Locale> supportedLocales = [en, zh];

  const LocaleService({Key key, this.builder}) : super(key: key);
  final LocaleServiceBuilder builder;

  @override
  _LocaleServiceState createState() => _LocaleServiceState();
}

class _LocaleServiceState extends State<LocaleService> {
  Locale _locale;

  _changeLocale(Locale locale) {
    assert(LocaleService.supportedLocales.contains(locale) || locale == null);
    return setState(() {
      return _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LocaleService(
      state: this,
      child: widget.builder(context, _locale),
    );
  }
}

class _LocaleService extends InheritedWidget {
  const _LocaleService({Key key, Widget child, this.state})
      : super(key: key, child: child);

  @visibleForTesting
  final _LocaleServiceState state;

  Locale get locale {
    return state._locale;
  }

  changeLocale(Locale locale) {
    return state._changeLocale(locale);
  }

  @override
  bool updateShouldNotify(covariant _LocaleService oldWidget) {
    return state != oldWidget.state;
  }
}

class StandardLocalizations {
  StandardLocalizations(this.locale);

  final Locale locale;

  static StandardLocalizations of(BuildContext context) {
    return Localizations.of<StandardLocalizations>(
        context, StandardLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'helloWorld': 'Hello World!',
      "sure": "Sure",
      "cancel": "Cancel",
      "home": "Home",
      "settings": "Settings",
      "darkTheme": "Dark Theme",
      "auto": "Auto",
      "about": "About",
      "language": "Language",
      "version": "Version",
      "framework": "Framework",
      "profile": "Profile",
      "source": "Source",
      "copy": "Copy",
      "paste": "Paste",
    },
    'zh': {
      'helloWorld': '你好👋',
      "sure": "确认",
      "cancel": "取消",
      "home": "主页",
      "settings": "设置",
      "darkTheme": "深色主题",
      "auto": "自动",
      "about": "关于",
      "language": "语言",
      "version": "版本",
      "framework": "框架",
      "profile": "个人资料",
      "source": "源代码",
      "copy": "复制",
      "paste": "粘贴",
    },
  };

  String get helloWorld {
    return _localizedValues[locale.languageCode]['helloWorld'];
  }

  String get home {
    return _localizedValues[locale.languageCode]['home'];
  }

  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get darkTheme {
    return _localizedValues[locale.languageCode]['darkTheme'];
  }

  String get auto {
    return _localizedValues[locale.languageCode]['auto'];
  }

  String get about {
    return _localizedValues[locale.languageCode]['about'];
  }

  String get language {
    return _localizedValues[locale.languageCode]['language'];
  }

  String get sure {
    return _localizedValues[locale.languageCode]['sure'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get version {
    return _localizedValues[locale.languageCode]['version'];
  }

  String get framework {
    return _localizedValues[locale.languageCode]['framework'];
  }

  String get profile {
    return _localizedValues[locale.languageCode]['profile'];
  }

  String get source {
    return _localizedValues[locale.languageCode]['source'];
  }

  String get copy {
    return _localizedValues[locale.languageCode]['copy'];
  }

  String get paste {
    return _localizedValues[locale.languageCode]['paste'];
  }
}

class StandardLocalizationsDelegate
    extends LocalizationsDelegate<StandardLocalizations> {
  const StandardLocalizationsDelegate(this.locale);

  final Locale locale;

  @override
  bool isSupported(Locale locale) =>
      StandardLocalizations._localizedValues.keys.contains(locale.languageCode);

  @override
  Future<StandardLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of StandardLocalizations.
    return SynchronousFuture<StandardLocalizations>(
        StandardLocalizations(locale));
  }

  @override
  bool shouldReload(covariant StandardLocalizationsDelegate old) {
    return true;
  }
}
