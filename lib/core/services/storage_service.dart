import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends StatelessWidget {
  static SharedPreferences of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_StorageService>()
        ?.storage;
  }

  final Widget child;

  const StorageService({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return SizedBox();
        return _StorageService(
          storage: snapshot.data,
          child: child,
        );
      },
    );
  }
}

class _StorageService extends InheritedWidget {
  const _StorageService({Key key, Widget child, this.storage})
      : super(key: key, child: child);

  final SharedPreferences storage;

  @override
  bool updateShouldNotify(covariant _StorageService oldWidget) {
    return oldWidget?.storage != storage;
  }
}
