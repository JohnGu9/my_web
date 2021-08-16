import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:my_web/core/core.dart';
import 'package:my_web/ui/layout_desktop/person_page.dart';
import 'package:my_web/ui/layout_desktop/setting_page.dart';
import 'package:my_web/ui/widgets/page_route_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Padding(
              padding: const EdgeInsets.only(left: 64),
              child: SizedBox(
                height: 56,
                width: 56,
                child: Builder(builder: (context) {
                  return Hero(
                    tag: Constants.personLogoImage,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Ink.image(
                        image: Constants.personLogoImage,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(CircularClipRoute(
                              expandFrom: context,
                              builder: (context) {
                                return const PersonPage();
                              },
                            ));
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            actions: [
              const Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const _ContactButton(),
              ),
              Tooltip(
                message: "https://github.com/JohnGu9",
                child: CupertinoButton(
                    child: const Text("Github"),
                    onPressed: () async {
                      if (await canLaunch("https://github.com/JohnGu9"))
                        launch("https://github.com/JohnGu9");
                    }),
              ),
              const SizedBox(width: 42),
              Hero(
                tag: "navigatorButton",
                child: Tooltip(
                  message: "Setting",
                  child: Builder(builder: (context) {
                    return CupertinoButton(
                        child: const Icon(Icons.menu),
                        onPressed: () {
                          Navigator.of(context).push(CircularClipRoute(
                            expandFrom: context,
                            builder: (context) {
                              return const SettingPage();
                            },
                          ));
                        });
                  }),
                ),
              ),
            ],
          ),
          body: const _Content(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: const [Colors.black, Colors.black, Colors.transparent],
          stops: const [0, 0.95, 1],
        ).createShader(bounds);
      },
      child: GroupAnimationService.passiveHost(
        animation: PageRouteAnimation.of(context).animation,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(width: 64),
            ),
            SliverToBoxAdapter(
              child: RotatedBox(
                quarterTurns: -1,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return RadialGradient(
                      center: Alignment.topLeft,
                      radius: 7.0,
                      colors: <Color>[
                        theme.textTheme.headline2!.color!,
                        Colors.blue
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Hybrid Development",
                    style: theme.textTheme.headline2
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(width: 108),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                const images = [
                  "undraw_Coding_re_iv62.svg",
                  "undraw_lightbulb_moment_re_ulyo.svg",
                  "undraw_fast_loading_re_8oi3.svg",
                  "undraw_Design_notes_re_eklr.svg",
                  "undraw_Modern_professional_re_3b6l.svg",
                ];
                const texts = [
                  "Build app for multi platforms. For desktop / for mobile. For Windows / for Linux. Even for embedded system. ",
                  "Build app into flexible forms. Cli or GUI. Professional or accessible",
                  "Build app under varied languages. C/C++, Java/Kotlin, Python, Dart and JavaScript. ",
                  "Build app with rich abilities. Access network, camera or hardware driver. Take advantage of database or text form data like xml or json. ",
                  "Build app more customizable. ",
                ];
                return GroupAnimationService.client(
                  builder: (BuildContext context, Animation<double> animation,
                      Widget child) {
                    const begin = Offset(1, 0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    return SlideTransition(
                      position: tween.animate(CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
                      child: child,
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index.isOdd) Spacer(),
                            Text(
                              "0${index + 1}",
                              style: theme.textTheme.headline1,
                            ),
                            AspectRatio(
                              aspectRatio: 3 / 4,
                              child: SvgPicture.asset(
                                  "assets/images/${images[index]}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Opacity(
                                opacity: 0.5,
                                child: Text(
                                  texts[index],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != 4)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: VerticalDivider(
                            width: 56,
                            thickness: 2,
                          ),
                        ),
                    ],
                  ),
                );
              }, childCount: 5),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(width: 108),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  const _ContactButton({Key? key}) : super(key: key);

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton>
    with SingleTickerProviderStateMixin {
  bool _onHovering = false;
  late AnimationController _controller;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = StandardLocalizations.of(context);
    return Tooltip(
      message: "johngustyle@outlook.com",
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.blue,
        child: InkWell(
          onTap: _onPressed,
          onHover: _onHover,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      layoutBuilder: (Widget? child, List<Widget> children) {
                        return Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.passthrough,
                          children: [if (child != null) child, ...children],
                        );
                      },
                      child: _onHovering
                          ? Text(
                              "Email",
                              key: const ValueKey(false),
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(
                              locale.contactMe,
                              key: const ValueKey(true),
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'johngustyle@outlook.com',
    );
    final urlString = emailLaunchUri.toString();
    if (await canLaunch(urlString))
      launch(urlString);
    else
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(
            leading: const Icon(Icons.error),
            title: Text("Can't launch email app. Please send email manually. "),
            subtitle: const SelectableText("johngustyle@outlook.com"),
            trailing: CupertinoButton(
              child: Text("Copy address"),
              onPressed: () {
                Clipboard.setData(
                    const ClipboardData(text: "johngustyle@outlook.com"));
              },
            ),
          ),
        ),
      );
  }

  void _onHover(bool value) {
    return setState(() {
      _onHovering = value;
    });
  }
}
