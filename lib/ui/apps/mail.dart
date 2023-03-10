import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Mail extends StatelessWidget {
  static final appData = AppData(
    app: const Mail(),
    icon: const Icon(
      Icons.mail,
      color: Colors.white,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.blue,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Mail',
  );

  const Mail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = ColorTween(
            begin: theme.colorScheme.background,
            end: theme.colorScheme.onBackground)
        .transform(0.08);
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Mailboxes"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                clipBehavior: Clip.hardEdge,
                color: cardColor,
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.all_inbox,
                        color: Colors.blue,
                      ),
                      title: Text("All Inboxes"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.inbox,
                        color: Colors.blue,
                      ),
                      title: Text("Gmail"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.inbox,
                        color: Colors.blue,
                      ),
                      title: Text("Outlook"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      title: Text("VIP"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _onTap() {}
