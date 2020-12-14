import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';
import 'package:my_web/ui/widgets/widgets.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = StandardLocalizations.of(context);
    return ScopeNavigatorProxy(
      builder: (BuildContext context, bool noRouteLayer, Widget child) {
        return child;
      },
      child: ScopeNavigator(
        spring: SpringProvideService.of(context),
        child: DefaultTabController(
          length: 4,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Material(
                  color: theme.primaryColor,
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: localizations.technologyStack),
                      Tab(text: localizations.programmingLanguage),
                      Tab(text: localizations.supportedPlatform),
                      Tab(text: localizations.otherRelatedStuff),
                    ],
                  ),
                ),
              ),
              const SliverFillRemaining(
                child: TabBarView(
                  children: const [
                    _TechnologyStackCard(),
                    _ProgrammingLanguage(),
                    _SupportPlatform(),
                    _OtherRelativeStuff(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TechnologyStackCard extends StatelessWidget {
  const _TechnologyStackCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text(localization.signalProcessing),
            subtitle: Card(
              color: Colors.black12,
              child: Column(
                children: [
                  ListTile(title: Text(localization.digitalSignalProcessing)),
                  ListTile(title: Text(localization.digitalImageProcessing)),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(localization.programming),
            subtitle: Card(
              color: Colors.black12,
              child: Column(
                children: [
                  ListTile(title: Text(localization.hardwareLanguage)),
                  ListTile(title: Text(localization.softwareLanguage)),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(localization.circuits),
            subtitle: Card(
              color: Colors.black12,
              child: Column(
                children: [
                  ListTile(title: Text(localization.analogCircuits)),
                  ListTile(title: Text(localization.digitalCircuits)),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(localization.computerNetwork),
          ),
        ),
      ],
    );
  }
}

class _ProgrammingLanguage extends StatelessWidget {
  const _ProgrammingLanguage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final languages = _content.keys.toList();
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (BuildContext context, int index) {
        final language = languages[index];
        return Tooltip(
          message: localization.tapAndExplore,
          child: Card(
            child: ListTile(
              title: Text(language),
              onTap: () {
                return _showProgramLanguagePage(context, language);
              },
            ),
          ),
        );
      },
    );
  }
}

class _SupportPlatform extends StatelessWidget {
  const _SupportPlatform({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return ListView(
      children: [
        Card(
          child: Column(
            children: [
              ListTile(title: Text(localization.usedFramework)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Chip(
                      label: const Text('Flutter'),
                    ),
                    const Chip(
                      label: const Text('PyQt5'),
                    ),
                    const Chip(
                      label: const Text('OpenCV'),
                    ),
                    const Chip(
                      label: const Text('Tensorflow'),
                    ),
                    const Chip(
                      label: const Text('Flask'),
                    ),
                    const Chip(
                      label: const Text('Electron'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(title: Text(localization.embeddedSystem)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Chip(
                      avatar: const Icon(Icons.developer_board),
                      label: const Text('STM32'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(title: Text(localization.desktop)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Chip(
                      avatar: const Icon(Icons.desktop_windows),
                      label: const Text('Windows'),
                    ),
                    const Chip(
                      avatar: const Icon(Icons.desktop_mac),
                      label: const Text('macOS'),
                    ),
                    const Tooltip(
                      message: "I prefer Ubuntu! CentOS and 'yum' is awful. ",
                      child: const Chip(
                        avatar: const Icon(Icons.desktop_windows_outlined),
                        label: const Text('Linux'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(title: Text(localization.mobile)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Tooltip(
                      message:
                          "I only have android phones when I was a student. Sorry IOS. ",
                      child: const Chip(
                        avatar: const Icon(Icons.android),
                        label: const Text('Android'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: ListTile(title: const Text("Web")),
        ),
        Card(
          child: ListTile(title: const Text("FPGA")),
        ),
      ],
    );
  }
}

class _OtherRelativeStuff extends StatelessWidget {
  const _OtherRelativeStuff({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StandardLocalizations.of(context);
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text(localization.whatIsMyAdvantage),
            subtitle: Card(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  localization.myAdvantageDescription,
                  style: theme.textTheme.caption,
                ),
              ),
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                title: RichText(
                  text: TextSpan(style: theme.textTheme.bodyText1, children: [
                    TextSpan(text: localization.learning),
                    const TextSpan(text: ' / '),
                    TextSpan(text: localization.interest),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: const [
                    const Chip(label: const Text('Swift')),
                    const Chip(label: const Text('Rust')),
                    const Chip(label: const Text('Go')),
                    const Chip(label: const Text('Kubernetes')),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: ListTile(
            title: Text(localization.database),
            subtitle: Card(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  localization.databaseDescription,
                  style: theme.textTheme.caption,
                ),
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(localization.machineLearning),
            subtitle: Card(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  localization.machineLearningAndAIDescription,
                  style: theme.textTheme.caption,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_showProgramLanguagePage(BuildContext context, String language) {
  final borderRadius =
      ((Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
          .borderRadius as BorderRadius);
  final data = _content[language];
  return ScopeNavigator.of(context).push(ScopePageRoute(
    builder: (context, animation, secondaryAnimation) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.only(
                topLeft: borderRadius.topLeft,
                bottomLeft: borderRadius.bottomLeft),
            clipBehavior: Clip.hardEdge,
            child: _ProgramLanguagePage(data: data),
          ),
        ),
      );
    },
  ));
}

class _ProgramLanguagePage extends StatelessWidget {
  const _ProgramLanguagePage({Key key, @required this.data}) : super(key: key);
  final _Data data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              final navigator = ScopeNavigator.of(context);
              if (navigator.canPop()) navigator.pop();
            },
          ),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(data.name),
            centerTitle: false,
            background: Padding(
              padding: const EdgeInsets.all(16.0),
              child: data.logo,
            ),
          ),
        ),
        SliverAppBar(
          textTheme: theme.textTheme,
          title: Text('Relative'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: data.chips,
            ),
          ),
        ),
        SliverAppBar(
          textTheme: theme.textTheme,
          title: Text('Description'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(data.description),
            )),
          ),
        ),
        SliverAppBar(
          textTheme: theme.textTheme,
          title: Text('Addition'),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(data.addition),
            )),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 50))
      ],
    );
  }
}

class _Data {
  final String name;
  final Widget logo;
  final String description;
  final String addition;
  final List<Widget> chips;

  const _Data(
      {this.name,
      this.logo = const FlutterLogo(),
      this.description,
      this.addition,
      this.chips});
}

const _content = {
  'C/C++': _c,
  'Java': _java,
  'Kotlin': _kotlin,
  'Python': _python,
  'Dart': _dart,
  'JavaScript': _javascript,
  'VHDL': _vhdl,
};

const _c = _Data(
  name: 'C/C++',
  logo: Image(image: Constants.cppLogoImage),
  chips: [
    Chip(label: Text('C++11')),
    Chip(label: Text('C++14')),
    Chip(
      avatar: const Icon(Icons.desktop_windows),
      label: Text('Desktop'),
    ),
    Chip(
      avatar: const Icon(Icons.developer_board),
      label: Text('Embedded System'),
    ),
    Chip(
      label: Image(
          image: Constants.cmakeLogoImage,
          height: 24,
          alignment: Alignment.center),
    ),
    Chip(
      avatar: Image(image: Constants.opencvLogoImage),
      label: Text('OpenCV'),
    ),
  ],
  description: '''The motherboard of most OOP language. 
With ability of control memory directly and natively. 
It's position can't be replaced for widely use. 
''',
  addition: '''My most familiar language with my most disgust. 
Some syntax and mechanism doesn't make sense at all 😡 but it will focus you to agree with it. 
But it have widely support and high performance. I forgive it. 
Makefile? No, I'm a CMake boy. 
''',
);

const _java = _Data(
  name: 'JAVA',
  logo: Image(image: Constants.javaLogoImage),
  chips: [
    Chip(label: Text('JAVA 1.8.0')),
    Chip(
      avatar: const Icon(Icons.android),
      label: Text('Android'),
    ),
    Chip(
      avatar: const Icon(Icons.desktop_windows),
      label: Text('Desktop'),
    ),
  ],
  description: '''The most famous OOP language. 
It was official language for android in the past. 
''',
  addition:
      '''@Deprecated( "My second programming language learnt in university. My familiar OOP language in the past. But I discard it now. It is out of data because it never include important high-level operations. No null safety, No coroutine. Some syntax is really redundant. Not a good choose for a big project. " )
class JAVA extends ProgrammingLanguage {}
''',
);

const _kotlin = _Data(
  name: 'Kotlin',
  logo: Image(image: Constants.kotlinLogoImage),
  chips: [
    Chip(label: Text('Kotlin 1.4^')),
    Chip(
      avatar: const Icon(Icons.android),
      label: Text('Android'),
    ),
  ],
  description:
      '''The well replacement of JAVA that offer rich and useful features such as null safety and ease syntax. 
And it's recommended by Google to implement feature while product Android program. 
''',
  addition:
      '''Kotlin offer more appealing features than JAVA that make me transform to it. 
Null safety, Coroutine, Lighting syntax. Well training, seems to be well prepared. 
But sometimes I'm still not satisfy with it. 
''',
);

const _python = _Data(
  name: 'Python',
  logo: Image(image: Constants.pythonLogoImage),
  chips: [
    Chip(label: Text('Python3')),
    Chip(
      avatar: const Icon(Icons.desktop_windows),
      label: Text('Desktop'),
    ),
    Chip(
      avatar: Image(image: Constants.qtLogoImage),
      label: Text('PyQt5'),
    ),
    Chip(
      avatar: Image(image: Constants.opencvLogoImage),
      label: Text('OpenCV'),
    ),
    Chip(
      avatar: Image(image: Constants.tensorflowLogoImage),
      label: Text('Tensorflow'),
    ),
    Chip(
      avatar: Image(image: Constants.flaskLogoImage),
      label: Text('Flask'),
    ),
  ],
  description: '''A ease language for programer or normal people. 
A Huge community offering rich packages. 
''',
  addition:
      '''Because Matlab is not free, it's the best replacement that can easily handle work for a student of signal relative major. 
And nowadays most common data progressing and scientific research built on it that I need to learn and use it. 
Also it make me get rid of shell. Just use Python make every things ease. Performance? Who care?
''',
);

const _dart = _Data(
  name: 'Dart',
  logo: Image(image: Constants.dartLogoImage),
  chips: [
    Chip(label: Text('Dart2.5^')),
    Chip(
      avatar: const Icon(Icons.android),
      label: Text('Android'),
    ),
    Chip(
      avatar: const Icon(Icons.phone_iphone),
      label: Text('IOS'),
    ),
    Chip(
      avatar: const Icon(Icons.web),
      label: Text('Web'),
    ),
    Chip(
      avatar: const Icon(Icons.desktop_mac),
      label: Text('macOS'),
    ),
    Chip(
      avatar: const Icon(Icons.design_services),
      label: Text('Frontend design'),
    ),
    Chip(
      avatar: const FlutterLogo(),
      label: Text('Flutter'),
    ),
  ],
  description: '''The cross-platform OOP language made by Google's team. 
It absorb all other OOP language advantages and abandon all disadvantage. 
Flutter is Dart's most famous package that commonly used for Android and IOS frontend programming. 
''',
  addition:
      '''The most suitable language for programer to use that it become my favorite programming language. 🥰
Everything just make such sense in it. Awesome syntax assistance out of the box. Awesome package management out of the box. 
But it still is a young language. Not everything is perfect. 
''',
);

const _javascript = _Data(
  name: 'JavaScript',
  logo: Image(image: Constants.javascriptLogoImage),
  chips: [
    Chip(label: Text('ES')),
    Chip(
      avatar: const Icon(Icons.web),
      label: Text('Web'),
    ),
    Chip(
      avatar: Image(image: Constants.nodejsLogoImage),
      label: Text('NodeJS'),
    ),
    Chip(
      avatar: Image(image: Constants.electronLogoImage),
      label: Text('Electron'),
    ),
    Chip(
      avatar: Image(image: Constants.typescriptLogoImage),
      label: Text('TypeScript'),
    ),
  ],
  description: '''The currency of world of web. 
Web application can never get rid of it (WebAssembly say: "Not that true. "). 
''',
  addition:
      '''A flexible language that ease to use. V8 engine JIT make its performance ridiculous. 
But it's too flexible that also ease to make mistake or make program vulnerability. 
''',
);

const _vhdl = _Data(
  name: 'VHDL',
  logo: SizedBox(),
  chips: [
    Chip(
      avatar: const Icon(Icons.developer_board),
      label: Text('Hardware language'),
    ),
    Chip(
      avatar: const Icon(Icons.developer_board),
      label: Text('EDA'),
    ),
    Chip(
      avatar: const Icon(Icons.developer_board),
      label: Text('FPGA'),
    ),
  ],
  description: '''Hardware language that different from software language. 
Everything run parallelling, just like OpenGL or CUDA, but without memory. 
''',
  addition: '''State machine. State machine. State switch. 
Rising edge or falling edge. 
library ieee;
''',
);
