import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/basic/constants.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              actions: [
                Hero(
                  tag: "navigatorButton",
                  child: CupertinoButton(
                    child: const Icon(Icons.close),
                    onPressed: Navigator.of(context).pop,
                  ),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Hero(
                          tag: Constants.personLogoImage,
                          child: Material(
                            shape: CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: Ink.image(
                              height: 250,
                              width: 250,
                              image: Constants.personLogoImage,
                              child: InkWell(
                                onTap: Navigator.of(context).pop,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          "John Gu",
                          style: theme.textTheme.headline4,
                        ),
                      ),
                      ListTile(
                        subtitle: Text(
                            "A software engineer. Worked on multi platforms that let me know different tools have different advantages under different cases. Development principle: suitable tools for certain cases is the best. \n\nWelcome business cooperation. "),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 8),
                        child: Text("Email"),
                      ),
                      CupertinoButton(
                        child: SelectableText("johngustyle@outlook.com"),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(
                              text: "johngustyle@outlook.com"));
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.hideCurrentSnackBar();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Email address (johngustyle@outlook.com) already copied to your clipboard. "),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: messenger.hideCurrentSnackBar,
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text("Social"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton(
                              child: Text("Youtube"),
                              onPressed: () {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text("Not available yet"),
                                    action: SnackBarAction(
                                      label: 'Close',
                                      onPressed: messenger.hideCurrentSnackBar,
                                    ),
                                  ),
                                );
                              }),
                          CupertinoButton(
                              child: Text("Twitter"),
                              onPressed: () {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text("Not available yet"),
                                    action: SnackBarAction(
                                      label: 'Close',
                                      onPressed: messenger.hideCurrentSnackBar,
                                    ),
                                  ),
                                );
                              }),
                          CupertinoButton(
                              child: Text("Facebook"),
                              onPressed: () {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text("Not available yet"),
                                    action: SnackBarAction(
                                      label: 'Close',
                                      onPressed: messenger.hideCurrentSnackBar,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          "Copyright (c) 2021 JohnGu9",
                          style: theme.textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
