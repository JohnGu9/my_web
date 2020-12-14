import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_web/core/services/locale_service.dart';
import 'dialog_transition.dart';

showVisitWebsiteDialog(BuildContext context, String url) async {
  return Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      final theme = Theme.of(context);
      return DialogTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: RawKeyboardListener(
          onKey: (RawKeyEvent event) async {
            if (event.logicalKey.keyId == 0x100070028) {
              // Enter key
              await launch(url);
              final navigator = Navigator.of(context);
              if (navigator.canPop()) navigator.pop(true);
            } else if (event.logicalKey.keyId == 0x100070029) {
              // Escape key
              final navigator = Navigator.of(context);
              if (navigator.canPop()) navigator.pop(false);
            }
          },
          focusNode: FocusNode()..requestFocus(),
          child: SafeArea(
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
                      title: Text(StandardLocalizations.of(context)
                          .toVisitOtherWebsite),
                      backgroundColor: theme.cardColor,
                      centerTitle: true,
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
                            if (await canLaunch(url)) await launch(url);
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
          ),
        ),
      );
    },
  ));
}
