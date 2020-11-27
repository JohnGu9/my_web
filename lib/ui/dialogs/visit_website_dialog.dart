import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_web/core/services/locale_service.dart';
import 'package:my_web/ui/widgets/scope_navigator.dart';
import 'dialog_transition.dart';

showVisitWebsiteDialog(BuildContext context, String url) async {
  if (await canLaunch(url))
    return ScopeNavigator.of(context).push(ScopePageRoute(
      builder: (context, animation, secondaryAnimation, size) {
        final theme = Theme.of(context);
        return DialogTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: Card(
            margin: const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: 300,
              child: ListView(
                shrinkWrap: true,
                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
                    textTheme: theme.textTheme,
                    title: Text(
                        StandardLocalizations.of(context).toVisitOtherWebsite),
                    backgroundColor: theme.cardColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(url, textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 16),
                  ButtonBar(
                    children: [
                      FlatButton(
                        onPressed: () {
                          final navigator = Navigator.of(context);
                          if (navigator.canPop()) navigator.pop(false);
                        },
                        child: Text(StandardLocalizations.of(context).cancel),
                      ),
                      RaisedButton.icon(
                        onPressed: () async {
                          await launch(url);
                          final navigator = Navigator.of(context);
                          if (navigator.canPop()) navigator.pop(true);
                        },
                        icon: Icon(Icons.near_me),
                        label: Text(StandardLocalizations.of(context).sure),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
}
