import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: theme.scaffoldBackgroundColor,
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
        body: Center(
          child: SizedBox(
            width: 300,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
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
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "John Gu",
                        style: theme.textTheme.headline4,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListTile(
                    subtitle: Text(
                        "A software engineer that develop all kind of application. Development principle: suitable tools for certain cases is the best. \n\nWelcome business cooperation. "),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
