import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});
  static final appData = AppData(
    app: const Notes(),
    icon: const Icon(
      Icons.notes,
      color: Colors.black,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Notes',
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Folder"),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text("Edit"),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  ListTile(
                    title: Text("zCloud"),
                    trailing: Icon(Icons.expand_more),
                  ),
                  ListTile(
                    leading: Icon(Icons.folder),
                    title: Text("Notes"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  ListTile(
                    title: Text("Gmail"),
                    trailing: Icon(Icons.expand_more),
                  ),
                  ListTile(
                    leading: Icon(Icons.folder),
                    title: Text("Notes"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
