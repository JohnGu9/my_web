import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Message extends StatelessWidget {
  const Message({super.key});
  static final appData = AppData(
    app: const Message(),
    icon: const Icon(
      Icons.chat_bubble,
      color: Colors.white,
      size: 48,
    ),
    iconBackground: Container(
      color: Colors.green,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Message',
  );

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
            title: const Text("Message"),
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
                        Icons.bubble_chart,
                        color: Colors.blue,
                      ),
                      title: Text("All Message"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      title: Text("Known Senders"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person_search,
                        color: Colors.blue,
                      ),
                      title: Text("Unknown Senders"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.mark_unread_chat_alt,
                        color: Colors.blue,
                      ),
                      title: Text("Unread message"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: _onTap,
                    ),
                  ],
                ),
              ),
            ),
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
                        Icons.delete,
                        color: Colors.blue,
                      ),
                      title: Text("Recently Deleted"),
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
