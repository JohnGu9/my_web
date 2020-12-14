import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';
import 'package:my_web/ui/dialogs/visit_website_dialog.dart';
import 'package:my_web/ui/widgets/widgets.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = StandardLocalizations.of(context);
    final animation = ScopePageRoute.of(context).animation;
    return GroupAnimationService.passiveHost(
      animation: animation,
      child: ListView(
        children: [
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              textTheme: theme.textTheme,
              title: Text(localizations.education),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: const _School(),
          ),
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: const _Major(),
          ),
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              textTheme: theme.textTheme,
              title: Text(localizations.experiment),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: const _EmbeddedEngineer(),
          ),
          GroupAnimationService.client(
            builder: _groupAnimationBuilder,
            child: const _CommunicationsEngineer(),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _groupAnimationBuilder(
      BuildContext context, Animation<double> animation, Widget child) {
    return SlideTransition(
        position: Tween(begin: const Offset(0.3, 0), end: Offset.zero)
            .animate(animation),
        child: FadeTransition(opacity: animation, child: child));
  }
}

class _School extends StatelessWidget {
  const _School({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            title: Text(localization.jnu),
            subtitle: Text(localization.university),
            trailing: const Icon(Icons.school),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Image(
                    image: Constants.jinanLogoImage,
                    height: 150,
                    width: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: localization.visit,
                    child: Chip(
                      label: const Text(
                        'https://www.jnu.edu.cn',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      useDeleteButtonTooltip: false,
                      deleteIcon: const Icon(Icons.near_me),
                      onDeleted: () {
                        return showVisitWebsiteDialog(
                            context, 'https://www.jnu.edu.cn');
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        label: Text(
                          'GuangDong - GuangZhou',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        label: Text(
                          '211',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Major extends StatelessWidget {
  const _Major({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            title: Text(localization.internetOfThings),
            subtitle: Text(localization.fourYearFullTime),
            trailing: const Icon(Icons.book),
          ),
          ListTile(
            title: Text(localization.coverage),
            subtitle: Text(
                '${localization.signalAndCommunication}\n${localization.electronicCircuit}\n${localization.computerScience}'),
          ),
        ],
      ),
    );
  }
}

class _EmbeddedEngineer extends StatelessWidget {
  const _EmbeddedEngineer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(localization.embeddedEngineer),
        trailing: Chip(label: Text(localization.practice)),
      ),
    );
  }
}

class _CommunicationsEngineer extends StatelessWidget {
  const _CommunicationsEngineer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = StandardLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(localization.communicationsEngineer),
      ),
    );
  }
}
