import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_web/core/constants.dart';

import 'package:my_web/core/services/group_animation_service.dart';
import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/core/services/spring_provide_service.dart';
import 'package:my_web/ui/home_page.dart';
import 'package:my_web/ui/widgets/scope_navigator.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homePage = HomePage.of(context);
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
    final borderRadius = cardShape.borderRadius as BorderRadius;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
            left: constraints.maxWidth * homePage.indexSpaceRate,
            top: homePage.padding + homePage.headerMinHeight,
            bottom: homePage.padding,
          ),
          child: Material(
            clipBehavior: Clip.hardEdge,
            elevation: homePage.elevation,
            color: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: borderRadius.topLeft,
                bottomLeft: borderRadius.bottomLeft,
              ),
            ),
            child: HomePage.scrollBarrier(page: 2, child: const _Content()),
          ),
        );
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key key}) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..animateTo(1.0, duration: const Duration(milliseconds: 2400));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopeNavigator(
      spring: spring,
      child: GroupAnimationService.passiveHost(
        animation: _controller,
        child: Row(
          children: [
            const Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _TechnologyStackCard(),
              ),
            ),
            const Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _ProgrammingLanguage(),
              ),
            ),
            const Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _SupportPlatform(),
              ),
            ),
            const Expanded(
              child: GroupAnimationService.client(
                builder: _animatedItemBuilder,
                child: _OtherStuff(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _animatedItemBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    final curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
    final position =
        Tween(begin: Offset(1, 0), end: Offset.zero).animate(curvedAnimation);
    return SlideTransition(
      position: position,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class _CardWrapper extends StatefulWidget {
  const _CardWrapper({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  __CardWrapperState createState() => __CardWrapperState();
}

class __CardWrapperState extends State<_CardWrapper>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {}

  void _onHover(bool value) {
    if (!mounted) return;
    _controller.animateWith(SpringSimulation(
        spring, _controller.value, value ? 1.0 : 0.0, _controller.velocity));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: InkWell(
        onTap: _onTap,
        onHover: _onHover,
        hoverColor: Colors.transparent,
        child: AnimatedBuilder(
          child: widget.child,
          animation: _controller,
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                cardTheme: theme.cardTheme.copyWith(
                  margin: EdgeInsetsTween(
                    begin: const EdgeInsets.all(6.0),
                    end: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 6.0),
                  ).evaluate(_controller),
                ),
              ),
              child: child,
            );
          },
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
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.technologyStack),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text(localization.signalProcessing),
                    subtitle: Card(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          ListTile(
                              title:
                                  Text(localization.digitalSignalProcessing)),
                          ListTile(
                              title: Text(localization.digitalImageProcessing)),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgrammingLanguage extends StatelessWidget {
  const _ProgrammingLanguage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final languages = _content.keys.toList();
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.programmingLanguage),
          ),
          Expanded(
            child: ListView.builder(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportPlatform extends StatelessWidget {
  const _SupportPlatform({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.supportedPlatform),
          ),
          Expanded(
            child: ListView(
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
                              message:
                                  "I prefer Ubuntu! CentOS and 'yum' is awful. ",
                              child: const Chip(
                                avatar:
                                    const Icon(Icons.desktop_windows_outlined),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherStuff extends StatelessWidget {
  const _OtherStuff({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StandardLocalizations.of(context);
    return _CardWrapper(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(localization.otherRelatedStuff),
          ),
          Expanded(
            child: ListView(
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
                          text: TextSpan(
                              style: theme.textTheme.bodyText1,
                              children: [
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
                          children: [
                            const Chip(
                              label: const Text('Swift'),
                            ),
                            const Chip(
                              label: const Text('Rust'),
                            ),
                            const Chip(
                              label: const Text('Go'),
                            ),
                            const Chip(
                              label: const Text('Kubernetes'),
                            ),
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
            ),
          ),
        ],
      ),
    );
  }
}

_showProgramLanguagePage(BuildContext context, String language) {
  final borderRadius =
      ((Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
          .borderRadius as BorderRadius);
  final data = _content[language];
  return ScopeNavigator.of(context).push(ScopePageRoute(
    builder: (context, animation, secondaryAnimation, size) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: FractionallySizedBox(
          alignment: Alignment.topRight,
          widthFactor: 6.0 / 7.0,
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
Huge community offering rich package. 
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
Everything run parallel, just like OpenGL or CUDA, but without memory. 
''',
  addition: '''State machine. State machine. State machine. 
Rising edge or falling edge. 
ieee.*
''',
);
