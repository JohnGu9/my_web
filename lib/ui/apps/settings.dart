import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Settings extends StatelessWidget {

  const Settings({super.key});
  static final appData = AppData(
    app: const Settings(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.grey.shade300,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Settings',
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
            title: const Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                clipBehavior: Clip.hardEdge,
                color: cardColor,
                child: ListTile(
                  leading: ClipOval(
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground.withOpacity(0.08),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.person,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                  title: const Text("JohnGu"),
                  subtitle: const Text("Zpple ID, zCloud+, Media & Purchases"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
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
                  children: [
                    _Tile(
                      leadingBackgroundColor: Colors.orange,
                      leading: const Icon(Icons.airplanemode_active),
                      title: const Text("Airplane Mode"),
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.blueAccent,
                      leading: const Icon(Icons.wifi),
                      title: const Text("WLAN"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("MyWifi"),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.blue,
                      leading: const Icon(Icons.bluetooth),
                      title: const Text("Bluetooth"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("On"),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.green,
                      leading: const Icon(Icons.podcasts),
                      title: const Text("Cellular"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [Icon(Icons.arrow_forward_ios)],
                      ),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.blue,
                      leading: const Icon(Icons.vpn_lock),
                      title: const Text("VPN"),
                      trailing: Switch(value: true, onChanged: (value) {}),
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
                    _Tile(
                      leadingBackgroundColor: Colors.deepOrange,
                      leading: Icon(Icons.notifications),
                      title: Text("Notifications"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.pink,
                      leading: Icon(Icons.volume_up),
                      title: Text("Sounds & Haptic"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.deepPurple,
                      leading: Icon(Icons.mode_night),
                      title: Text("Focus"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    _Tile(
                      leadingBackgroundColor: Colors.deepPurple,
                      leading: Icon(Icons.timelapse),
                      title: Text("Screen Time"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 64)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
      {required this.leadingBackgroundColor,
      required this.leading,
      required this.title,
      required this.trailing});
  final Color leadingBackgroundColor;
  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: leadingBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: leading,
        ),
      ),
      title: title,
      trailing: trailing,
      onTap: () {},
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: Center(
        child: Icon(
          Icons.settings,
          color: Colors.grey.shade300,
          size: 48,
        ),
      ),
    );
  }
}
