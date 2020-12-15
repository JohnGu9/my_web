import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';
import 'package:my_web/ui/widgets/widgets.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final animation = ScopePageRoute.of(context).animation;
    return GroupAnimationService.passiveHost(
      animation: animation,
      child: ListView(
        children: const [
          GroupAnimationService.client(
              builder: _animatedItemBuilder, child: _MyHobbies()),
          GroupAnimationService.client(
              builder: _animatedItemBuilder, child: _MyExpectation()),
          GroupAnimationService.client(
              builder: _animatedItemBuilder, child: _More()),
        ],
      ),
    );
  }
}

class _MyHobbies extends StatelessWidget {
  const _MyHobbies({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localizations = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Text(localizations.myHobbies),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              textTheme: theme.textTheme),
          Card(
            elevation: 0.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(title: Text(localizations.game)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: const [
                        Chip(label: Text('GTA5')),
                        Chip(label: Text('The Division')),
                        Chip(label: Text('BattleFelid 1')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text(localizations.electronicProduction),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: const [
                        Chip(label: Text('Computer')),
                        Chip(label: Text('Phone')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyExpectation extends StatelessWidget {
  const _MyExpectation({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Text(localization.myExpectation),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              textTheme: theme.textTheme),
          Card(
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(localization.myExpectationDescription),
            ),
          ),
        ],
      ),
    );
  }
}

class _More extends StatelessWidget {
  const _More({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(localization.more),
            textTheme: theme.textTheme,
          ),
          Card(
            elevation: 0.0,
            child: ListTile(
              title: const Text('1996'),
              trailing: const Icon(Icons.calendar_today),
              subtitle: Text(localization.born),
            ),
          ),
          const Card(
            elevation: 0.0,
            child: ListTile(
              title: const Text('English'),
              trailing: const Chip(
                label: Text('CET 4'),
              ),
            ),
          ),
          const _MyDevelopment(),

          // Card(
          //   elevation: 0.0,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 8.0),
          //     child: ListTile(
          //       title: Text(localization.attention),
          //       subtitle: Text(localization.attentionDescription),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _MyDevelopment extends StatefulWidget {
  const _MyDevelopment({Key key}) : super(key: key);

  @override
  __MyDevelopmentState createState() => __MyDevelopmentState();
}

class __MyDevelopmentState extends State<_MyDevelopment>
    with SingleTickerProviderStateMixin, SpringProvideStateMixin {
  AnimationController _controller;
  bool _isOpened;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
    _isOpened = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              _isOpened = !_isOpened;
              _controller.animationWithSpring(spring, _isOpened ? 1 : 0);
            },
            title: const Text('Visual Studio Code'),
            trailing: const Icon(Icons.code),
            subtitle: Text('${localization.favorite} IDE'),
          ),
          SizeTransition(
            sizeFactor: _controller,
            axis: Axis.vertical,
            child: Stack(
              children: [
                const Image(
                  image: Constants.myDevelopmentImage,
                  width: double.infinity,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.build_circle, size: 48),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _animatedItemBuilder(
    BuildContext context, Animation<double> animation, Widget child) {
  return ScaleTransition(
    scale: animation,
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
