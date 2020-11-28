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
      "distTechnique": "Dist Technique",
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
      "tapAndExplore": "Tap and explore",
      // background page
      "university": "University",
      "JNU": "JNU University",
      "fourYearFullTime": "four-year full-time",
      "internetOfThings": "Internet of Things",
      // skill page
      "techniqueStack": "Technique Stack",
      "programmingLanguage": "Programming Language",
      "supportedPlatform": "Supported Platform",
      "otherRelatedStuff": "Other Related Stuff",

      "signalProcessing": "Signal Processing",
      "digitalSignalProcessing": "Digital Signal Processing",
      "digitalImageProcessing": "Digital Image Processing",
      "circuits": "Circuits",
      "analogCircuits": "Analog Circuits",
      "digitalCircuits": "Digital Circuits",
      "programming": "Programming",
      "hardwareLanguage": "Hardware Language",
      "softwareLanguage": "Software Language",
      "computerNetwork": "Computer Network",
      "embeddedSystem": "Embedded System",
      "desktop": "Desktop",
      "mobile": "Mobile",
      "usedFramework": "Used Framework",
      "whatIsMyAdvantage": "What is my advantage?",
      "@myAdvantageDescription": _myAdvantageDescriptionEN,
      "learning": "Learning",
      "interest": "interest",
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
      "distTechnique": "应用分发技术",
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
      "tapAndExplore": "点击查看",
      // background page
      "university": "大学",
      "JNU": "暨南大学",
      "fourYearFullTime": "四年全日制",
      "internetOfThings": "物联网工程",
      // skill page
      "techniqueStack": "技术栈",
      "programmingLanguage": "编程语言",
      "supportedPlatform": "支持平台",
      "otherRelatedStuff": "其他相关内容",
      "signalProcessing": "信号处理",
      "digitalSignalProcessing": "数字信号处理",
      "digitalImageProcessing": "数字图像处理",
      "circuits": "电路",
      "analogCircuits": "模拟电路",
      "digitalCircuits": "数字信号",
      "programming": "编程",
      "hardwareLanguage": "硬件语言",
      "softwareLanguage": "软件语言",
      "computerNetwork": "计算机网络",
      "embeddedSystem": "嵌入式系统",
      "desktop": "桌面系统",
      "mobile": "移动系统",
      "usedFramework": "使用过的框架",
      "whatIsMyAdvantage": "我的优势是什么？",
      "@myAdvantageDescription": _myAdvantageDescriptionZH,
      "learning": "学习中",
      "interest": "感兴趣",
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

  String get distTechnique {
    return _localize['distTechnique'];
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

  String get tapAndExplore {
    return _localize['tapAndExplore'];
  }

  String get university {
    return _localize['university'];
  }

  String get jnu {
    return _localize['JNU'];
  }

  String get fourYearFullTime {
    return _localize['fourYearFullTime'];
  }

  String get internetOfThings {
    return _localize['internetOfThings'];
  }

  String get techniqueStack {
    return _localize['techniqueStack'];
  }

  String get programmingLanguage {
    return _localize['programmingLanguage'];
  }

  String get supportedPlatform {
    return _localize['supportedPlatform'];
  }

  String get otherRelatedStuff {
    return _localize['otherRelatedStuff'];
  }

  String get signalProcessing {
    return _localize['signalProcessing'];
  }

  String get digitalSignalProcessing {
    return _localize['digitalSignalProcessing'];
  }

  String get digitalImageProcessing {
    return _localize['digitalImageProcessing'];
  }

  String get circuits {
    return _localize['circuits'];
  }

  String get analogCircuits {
    return _localize['analogCircuits'];
  }

  String get digitalCircuits {
    return _localize['digitalCircuits'];
  }

  String get programming {
    return _localize['programming'];
  }

  String get hardwareLanguage {
    return _localize['hardwareLanguage'];
  }

  String get softwareLanguage {
    return _localize['softwareLanguage'];
  }

  String get computerNetwork {
    return _localize['computerNetwork'];
  }

  String get embeddedSystem {
    return _localize['embeddedSystem'];
  }

  String get desktop {
    return _localize['desktop'];
  }

  String get mobile {
    return _localize['mobile'];
  }

  String get usedFramework {
    return _localize['usedFramework'];
  }

  String get whatIsMyAdvantage {
    return _localize['whatIsMyAdvantage'];
  }

  String get myAdvantageDescription {
    return _localize['@myAdvantageDescription'];
  }

  String get learning {
    return _localize['learning'];
  }

  String get interest {
    return _localize['interest'];
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

const _myAdvantageDescriptionEN = '''Wide techniques support. 

  I can offer multi techniques support and technology integration. In a most common situation, different staff from different tech divisions can communication between each other because of lack tech background knowledge of side other. 
  Although I can use all this technique as skilled as a dedicated pro technical staff at the beginning, I can switch among and into them easily. 
  But that is not meaning I can't develop independently. I can develop as normal developer alone, bundle all the stuff together and distribute a full production. 
''';
const _myAdvantageDescriptionZH = '''广泛的技术支持。

  我可以提供多层次技术和技术整合。一个常见的情况，来自不同的部门的技术人员常常因为缺乏对方专业的知识背景而彼此之间缺乏有效的沟通。
  尽管我无法像那些专攻某项技术的人那样马上熟练运用各个专门的技术，但我可以在这些技术之间自由切换和融入其中。
  但这并不意味着我无法独立完成开发，我完全可以像普通的开发者完成开发任务，打包全部的内容做成一个独立完整的产品。
''';
