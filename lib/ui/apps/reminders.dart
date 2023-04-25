import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Reminders extends StatelessWidget {
  const Reminders({super.key});
  static final appData = AppData(
    app: const Reminders(),
    icon: const Icon(
      Icons.list,
      color: Colors.grey,
      size: 56,
    ),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Reminders',
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                color: Colors.white30,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      ),
                      Text("Search"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 5 / 3,
              ),
              delegate: SliverChildListDelegate.fixed([
                _Card(
                  text: "Today",
                  color: Colors.blue,
                  icon: Icons.calendar_today,
                ),
                _Card(
                  text: "Scheduled",
                  color: Colors.red,
                  icon: Icons.calendar_month,
                ),
                _Card(
                  text: "All",
                  color: Colors.grey,
                  icon: Icons.inbox,
                ),
                _Card(
                  text: "Flag",
                  color: Colors.orange,
                  icon: Icons.flag,
                ),
                _Card(
                  text: "Completed",
                  color: Colors.blueGrey,
                  icon: Icons.check,
                ),
              ]),
            ),
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
                    leading: Icon(Icons.list),
                    title: Text("Remainders"),
                    trailing: Icon(Icons.arrow_forward_ios),
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

class _Card extends StatelessWidget {
  const _Card({
    required this.text,
    required this.color,
    required this.icon,
  });
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      color: Colors.white30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                )
              ],
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
