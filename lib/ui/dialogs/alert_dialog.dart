import 'package:flutter/material.dart';
import 'package:my_web/core/services/locale_service.dart';

import 'dialog_transition.dart';

showAlertDialog(BuildContext context, String message) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final theme = Theme.of(context);
        return DialogTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: RawKeyboardListener(
            onKey: (RawKeyEvent event) async {
              if (event.logicalKey.keyId == 0x100070028) {
                // Enter key
                final navigator = Navigator.of(context);
                if (navigator.canPop()) navigator.pop();
              } else if (event.logicalKey.keyId == 0x100070029) {
                // Escape key
                final navigator = Navigator.of(context);
                if (navigator.canPop()) navigator.pop();
              }
            },
            focusNode: FocusNode()..requestFocus(),
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
                      title: Text(StandardLocalizations.of(context).alert),
                      backgroundColor: theme.cardColor,
                      centerTitle: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          SelectableText(message, textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 16),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {
                            final navigator = Navigator.of(context);
                            if (navigator.canPop()) navigator.pop();
                          },
                          child: Text(StandardLocalizations.of(context).sure),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black38,
    ),
  );
}
