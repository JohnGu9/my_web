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
  StandardLocalizations(this.locale)
      : _localize = _localizedValues[locale.languageCode] ?? Map();

  final Locale locale;
  final Map<String, String> _localize;

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
      "more": "More",
      "background": "Background",
      "skill": "Skill",
      "other": "Other",
      "@backgroundDescription":
          "About my education and experiment?\nWhere did I graduate from?\nWhat's my major?\nWhat have I done?",
      "@skillDescription":
          "About my skills and ability\nWhat can I do?\nWhat's my tech stack?\nWhere's my focus?",
      "@otherDescription": "About my other stuff\nWhat's my hobby?",
      "visit": "Visit",
      "toVisitOtherWebsite": "To visit other website",
      "education": "Education",
      "experiment": "Experiment",
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
      "skill": "技能",
      "background": "背景",
      "more": "更多",
      "other": "其他",
      "@backgroundDescription": "关于我的教育与项目经验\n我的大学？\n我的专业？",
      "@skillDescription": "关于我的技术与能力\n我能做什么？\n我的技术栈有什么？\n我想专注的方向？",
      "@otherDescription": "有关我的其他方面\n我的爱好？",
      "visit": "访问",
      "toVisitOtherWebsite": "准备跳转其他网站",
      "education": "教育",
      "experiment": "履历",
    },
  };

  String get helloWorld {
    return _localize['helloWorld'];
  }

  String get home {
    return _localize['home'];
  }

  String get settings {
    return _localize['settings'];
  }

  String get darkTheme {
    return _localize['darkTheme'];
  }

  String get auto {
    return _localize['auto'];
  }

  String get about {
    return _localize['about'];
  }

  String get language {
    return _localize['language'];
  }

  String get sure {
    return _localize['sure'];
  }

  String get cancel {
    return _localize['cancel'];
  }

  String get version {
    return _localize['version'];
  }

  String get framework {
    return _localize['framework'];
  }

  String get profile {
    return _localize['profile'];
  }

  String get source {
    return _localize['source'];
  }

  String get copy {
    return _localize['copy'];
  }

  String get paste {
    return _localize['paste'];
  }

  String get skill {
    return _localize['skill'];
  }

  String get background {
    return _localize['background'];
  }

  String get more {
    return _localize['more'];
  }

  String get other {
    return _localize['other'];
  }

  String get visit {
    return _localize['visit'];
  }

  String get toVisitOtherWebsite {
    return _localize['toVisitOtherWebsite'];
  }

  String get education {
    return _localize['education'];
  }

  String get experiment {
    return _localize['experiment'];
  }

  String get backgroundDescription {
    return _localize['@backgroundDescription'];
  }

  String get skillDescription {
    return _localize['@skillDescription'];
  }

  String get otherDescription {
    return _localize['@otherDescription'];
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
