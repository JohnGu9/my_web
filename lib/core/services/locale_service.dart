import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/services/storage_service.dart';

typedef LocaleServiceBuilder = Widget Function(
    BuildContext context, Locale locale);

class LocaleService extends StatefulWidget {
  static _LocaleService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LocaleService>();
  }

  static const _map = {
    'en': en,
    'zh': zh,
  };
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
  static const _key = 'LocaleService';
  static final _availableFont = <String, AsyncFontFile>{
    'en': AsyncFontFile(), // no need to load additional font file
    'zh': AsyncFontFile(
        path: 'assets/fonts/Noto_Sans_SC/NotoSansSC-Light.otf',
        fontFamily: 'Noto Sans SC')
  };

  Locale _locale;
  Future<bool> _init;

  _changeLocale(Locale locale) async {
    assert(LocaleService.supportedLocales.contains(locale) || locale == null);
    final storage = StorageService.of(context);
    await storage.setString(_key, locale?.languageCode);
    if (mounted)
      setState(() {
        return _locale = locale;
      });
  }

  FutureOr<bool> _loadFont(Locale locale) {
    if (locale == null) return true;
    final asyncFile = _availableFont[locale.languageCode];
    if (asyncFile == null) return false;
    if (asyncFile.isLoaded) return true;
    asyncFile.loadFuture ??= () async {
      print('Async load font');
      try {
        final fontFile = await rootBundle.load(asyncFile.path);
        await loadFontFromList(fontFile.buffer.asUint8List(),
            fontFamily: asyncFile.fontFamily);
      } catch (error) {
        print(error);
        return false;
      }
      return true;
    }();
    return asyncFile.loadFuture;
  }

  FutureOr<bool> _checkLoadingFont(Locale locale) {
    if (locale == null) return true;
    final asyncFile = _availableFont[locale.languageCode];
    if (asyncFile.isLoaded) return true;
    return asyncFile.loadFuture;
  }

  _resetLocale() {
    final storage = StorageService.of(context);
    storage.setString(_key, null);
    _locale = null;
  }

  @override
  void didChangeDependencies() {
    final storage = StorageService.of(context);
    try {
      _locale = LocaleService._map[storage.getString(_key)];
      final load = _loadFont(_locale);
      if (load is Future<bool>)
        _init = load;
      else
        _init = Future.value(load as bool);
    } catch (error) {
      print(error);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _LocaleService(
      state: this,
      child: FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return const SizedBox();
          if (snapshot.hasError) _resetLocale();
          return widget.builder(context, _locale);
        },
      ),
    );
  }
}

class _LocaleService extends InheritedWidget {
  _LocaleService({Key key, Widget child, this.state})
      : locale = state._locale,
        super(key: key, child: child);

  final Locale locale;

  @visibleForTesting
  final _LocaleServiceState state;

  changeLocale(Locale locale) {
    return state._changeLocale(locale);
  }

  FutureOr<bool> loadFont(Locale locale) {
    return state._loadFont(locale);
  }

  FutureOr<bool> checkLoadingFont(Locale locale) {
    return state._checkLoadingFont(locale);
  }

  String get fontFamily {
    if (state._locale == null) return null;
    return _LocaleServiceState
        ._availableFont[state._locale.languageCode].fontFamily;
  }

  @override
  bool updateShouldNotify(covariant _LocaleService oldWidget) {
    return state != oldWidget.state || oldWidget.locale != locale;
  }
}

class AsyncFontFile {
  final String path;
  final String fontFamily;
  Future<bool> _loadFuture;
  Future<bool> get loadFuture {
    return _loadFuture;
  }

  set loadFuture(Future<bool> future) {
    loading = true;
    _loadFuture = future
      ..whenComplete(() {
        loading = false;
        isLoaded = true;
      })
      ..catchError((error) {
        loading = false;
        isLoaded = false;
        _loadFuture = null;
      });
  }

  bool loading = false;
  bool isLoaded;

  AsyncFontFile({this.path, this.fontFamily}) : isLoaded = path == null;
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
      "@otherDescription":
          "About my other stuff\nWhat's my hobby?\nOr somethings else?",
      "visit": "Visit",
      "toVisitOtherWebsite": "To visit other website",
      "education": "Education",
      "experiment": "Experiment",
      "tapAndExplore": "Tap and explore",
      "alert": "Alert",
      "useChromeForBetterExperiment": "Use Chrome for better experiment",
      "born": "Born",
      "favorite": "Favorite",
      "contactMe": "Contact Me",
      "attention": "Attention",
      "@attentionDescription": _attentionDescriptionEN,

      // background page
      "university": "University",
      "JNU": "JNU University",
      "fourYearFullTime": "four-year full-time",
      "internetOfThings": "Internet of Things",
      // skill page
      "technologyStack": "Technology Stack",
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
      "database": "Database",
      "@databaseDescription": _databaseDescriptionEN,
      "machineLearning": "Machine Learning",
      "@machineLearningAndAIDescription": _machineLearningAndAIDescriptionEN,
      "coverage": "Coverage",
      "signalAndCommunication": "Signal and Communication",
      "electronicCircuit": "Electronic Circuit",
      "computerScience": "Computer Science",
      "embeddedEngineer": "Embedded Development Engineer",
      "communicationsEngineer": "Communications Engineer",
      "practice": "Practice",
      "myHobbies": "My Hobbies",
      "myExpectation": "My Expectation",
      "@myExpectationDescription": _myExpectationDescriptionEN,
      "game": "Game",
      "electronicProduction": "Electronic Production",
      "preferIde": "Prefer IDE",
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
      "@otherDescription": "有关我的其他方面\n我的爱好？\n或者是其他内容",
      "visit": "访问",
      "toVisitOtherWebsite": "准备跳转其他网站",
      "education": "教育",
      "experiment": "履历",
      "tapAndExplore": "点击查看",
      "alert": "警告",
      "useChromeForBetterExperiment": "使用Chrome获得更好的体验",
      "born": "出生",
      "favorite": "最爱",
      "contactMe": "联系我",
      "attention": "注意",
      "@attentionDescription": _attentionDescriptionZH,

      // background page
      "university": "大学",
      "JNU": "暨南大学",
      "fourYearFullTime": "四年全日制",
      "internetOfThings": "物联网工程",
      // skill page
      "technologyStack": "技术栈",
      "programmingLanguage": "编程语言",
      "supportedPlatform": "支持平台",
      "otherRelatedStuff": "其他相关内容",
      "signalProcessing": "信号处理",
      "digitalSignalProcessing": "数字信号处理",
      "digitalImageProcessing": "数字图像处理",
      "circuits": "电路",
      "analogCircuits": "模拟电路",
      "digitalCircuits": "数字电路",
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
      "database": "数据库",
      "@databaseDescription": _databaseDescriptionZH,
      "machineLearning": "机器学习",
      "@machineLearningAndAIDescription": _machineLearningAndAIDescriptionZH,
      "coverage": "涵盖范围",
      "signalAndCommunication": "信号与通信",
      "electronicCircuit": "电子电路",
      "computerScience": "计算机科学",
      "embeddedEngineer": "嵌入式开发工程师",
      "communicationsEngineer": "通信工程师",
      "practice": "实习",
      "myHobbies": "我的爱好",
      "myExpectation": "我的期望",
      "@myExpectationDescription": _myExpectationDescriptionZH,
      "game": "游戏",
      "electronicProduction": "电子产品",
      "preferIde": "偏好的IDE",
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

  String get alert {
    return _localize['alert'];
  }

  String get useChromeForBetterExperiment {
    return _localize['useChromeForBetterExperiment'];
  }

  String get born {
    return _localize['born'];
  }

  String get favorite {
    return _localize['favorite'];
  }

  String get contactMe {
    return _localize['contactMe'];
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

  String get technologyStack {
    return _localize['technologyStack'];
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

  String get database {
    return _localize['database'];
  }

  String get databaseDescription {
    return _localize['@databaseDescription'];
  }

  String get machineLearning {
    return _localize['machineLearning'];
  }

  String get machineLearningAndAIDescription {
    return _localize['@machineLearningAndAIDescription'];
  }

  String get coverage {
    return _localize['coverage'];
  }

  String get signalAndCommunication {
    return _localize['signalAndCommunication'];
  }

  String get electronicCircuit {
    return _localize['electronicCircuit'];
  }

  String get computerScience {
    return _localize['computerScience'];
  }

  String get embeddedEngineer {
    return _localize['embeddedEngineer'];
  }

  String get communicationsEngineer {
    return _localize['communicationsEngineer'];
  }

  String get practice {
    return _localize['practice'];
  }

  String get myHobbies {
    return _localize['myHobbies'];
  }

  String get myExpectation {
    return _localize['myExpectation'];
  }

  String get myExpectationDescription {
    return _localize['@myExpectationDescription'];
  }

  String get game {
    return _localize['game'];
  }

  String get electronicProduction {
    return _localize['electronicProduction'];
  }

  String get attention {
    return _localize['attention'];
  }

  String get attentionDescription {
    return _localize['@attentionDescription'];
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

const _myAdvantageDescriptionEN = '''Wide technology support. 

  I can offer multi techniques support and technology integration. In a most common problem, different staff from different tech divisions can communication between each other because of lack tech background knowledge of side other. 
  Although I can't use all this technique as skilled as a dedicated pro technical staff at the beginning, I can switch among and into them easily. I can develop any projects of my felids. 
  But that is not meaning I can't develop independently. I can develop as normal developer alone, bundle all the stuff together and distribute a full production. 
''';
const _myAdvantageDescriptionZH = '''广泛的技术支持。

  我可以提供多层次技术和技术整合。一个常见的问题，来自不同的部门的技术人员常常因为缺乏对方专业的知识背景而彼此之间缺乏有效的沟通。
  尽管我无法像那些专攻某项技术的人那样马上熟练运用各个专门的技术，但我可以在这些技术之间自由切换和融入其中。任何方向的项目我都可以上手直接开发。
  但这并不意味着我无法独立完成开发，我完全可以像普通的开发者完成开发任务，打包全部的内容做成一个独立完整的产品。
''';

const _databaseDescriptionEN =
    '''This question just like asking me: "Did you save money in certain bank?". 
  "I have not done. " as my answer. 
  Different situations need different type databases. Even same type databases have their own implements with different apis or SQL language. 
  Map / Tree / Relational database is the most common type database. And each type have several famous productions in the market. I have not used them all in my short life. 
  Or I just don't care database. It's just a simple tool to save my data and should be like that. ''';
const _databaseDescriptionZH = '''这个问题仿佛就像我”是否去过某个银行存过钱？“
  我的回答是我还没有。
  不同的应用场景需要不同类型的数据库。即使同类的数据库也有自己的实现，便会有与之对应的API或者SQL语言。
  表型/树形/关系型数据库是最常见的数据库类型，而其中每种在市面上都有数个有名的产品。在我短暂的生涯里我还没用过它们全部。
  或者说我并不关心数据库究竟是怎样的，它仅仅是一个简单的用于存储数据的工具，而且本应该是这样。''';

const _machineLearningAndAIDescriptionEN =
    '''I know a bit. I'm familiar with the underlay some algorithm and constructions of machine learning. 
  When I was in the university, I was very interesting about this and learning a lot of relative theories. I have write a native c program "Image recognize based on machine learning" that ran on a STM32M3 development board. 
  But I wish you clam down. ML is not magic that can't finish any your whimsical ideas and it consume a lot of computer resource, time and people resource that only can reach the business production level. 
  If your company don't focus on it but want integrate it into own production, I recommend you try Google's ML Kit. 
  Of course, I'm glad to join your AI team and receive more salary. Because I need more pay to appease myself while I want to try new stuff but be requested to some repetitive work like a test engineer and try hard to optimize production like a framework developer. ''';
const _machineLearningAndAIDescriptionZH = '''我了解一点点。我熟悉机器学习一些底层的算法、逻辑和构成。
  当我在大学的时候，对其非常感兴趣，在网上搜索和学习很多相关的原理，在一次嵌入式课程作业我以自己对其理解编写了一个最简易的基于机器学习的图像识别的C程序并在STM32M3上运行。
  但是我还是希望你可以冷静，机器学习不是魔法，它不可能实现你任意异想天开的想法，同时它需要大量的运算资源和时间人力资源的投入才能产出一些能达到商业级别的产品。
  如果贵公司的主业不是这方面，又希望自己产品有相关属性，我推荐你们还是使用Google的ML Kit实现相关功能。
  当然我不介意你支付更高的薪金让我加入到你们的AI团队，毕竟让一个整天想着尝试新事物的人，去像测试工程师那样无休止的重复一些简单工作又要像框架师那样绞尽脑汁的优化产品，是需要更多的安慰费的。''';

const _myExpectationDescriptionEN =
    ''' I don't want to be only certain developer. I want to try and deep dive into every direction technology. And bundle them together. The road is more suitable for my style and my major. 
  As long as enough freedom of development for me, I can handle almost normal everything by myself (except center or complex problems). I'm suitable for development only. 
  And image processing is my most interesting felid. I'm glad to join into the felid and offer my ability. ''';
const _myExpectationDescriptionZH =
    ''' 我不希望仅仅只从事某一方面的开发。我希望可以尝试和深入每个方面的技术，并整合它们到一起。这样的方向才更符合我的风格和我的专业方向。
  只要给我足够的开发自由度，一般的问题（不涉及顶尖复杂的学术问题）我自己一个人就能解决。（我只适合开发）
  当然图像处理是我最感兴趣的领域，我会很高兴加入这个领域并做出我的贡献。''';

const _attentionDescriptionEN = 'Don\'t expect me to be cheap. '
    'IoT salary is to be over 10k yuan monthly in average in China. Don\'t disturb me with less than 200k annually. '
    'And don\'t ask me some question do nothing with my profession or my ability in the interview. Just tell how much you can pay directly. '
    'If you consider me not suitable for your company, just tell me directly in the interview. I wouldn\'t waste time to wait for the feedback by phone. ';
const _attentionDescriptionZH = '我不会很掉价的。'
    'IoT本科毕业的行业平均月薪都在1万以上，少于20万年薪的话就不要来打扰我了。'
    '也请不要在面试时问我一些和我专业或者技能毫不相关的东西。就直接告诉我你们能出多少，不用拐着弯来问我。'
    '如果你觉得我不适合你们公司，也请在面试时直接告诉我，我不会去浪费时间去等你们电话反馈。';
