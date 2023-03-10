import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends StatefulWidget {
  const SettingsProvider({super.key, required this.child});
  final Widget child;

  @override
  State<SettingsProvider> createState() => _SettingsProviderState();
}

class _SettingsProviderState extends State<SettingsProvider> {
  static final _sharePreferenceFuture = SharedPreferences.getInstance()
    ..then((value) => _sharePreference = value);
  static SharedPreferences? _sharePreference;

  Settings? _instance;

  Future _clear() async {
    setState(() {
      _instance = null;
    });
    final preferences = await _sharePreferenceFuture;
    await preferences.clear();
    setState(() {
      _instance = Settings(preferences, _clear);
    });
  }

  @override
  void initState() {
    super.initState();
    final sharePreference = _sharePreference;
    if (sharePreference != null) {
      _instance = Settings(sharePreference, _clear);
    } else {
      _sharePreferenceFuture.then((value) {
        setState(() {
          _instance = Settings(value, _clear);
        });
      });
    }
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsProvider(
      initiating: _sharePreference == null,
      instance: _instance,
      child: widget.child,
    );
  }
}

class Settings {
  const Settings(this.preferences, this.clear);
  static Settings? mayOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SettingsProvider>()
        ?.instance;
  }

  static bool? initiating(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SettingsProvider>()
        ?.initiating;
  }

  final SharedPreferences preferences;
  final Future Function() clear;

  setValue<T>(String key, T value) {
    if (value is int) {
      preferences.setInt(key, value);
    } else if (value is bool) {
      preferences.setBool(key, value);
    } else if (value is double) {
      preferences.setDouble(key, value);
    } else if (value is String) {
      preferences.setString(key, value);
    } else if (value is List<String>) {
      preferences.setStringList(key, value);
    } else {
      throw TypeError();
    }
  }

  T? getValue<T>(String key) {
    final value = preferences.get(key);
    if (value is T?) return value;
    if (value is List) {
      // shared_preferences bug
      // set as List<String> but get return as List<Object>
      // the below code is for transforming data to right type
      return value.map((e) => e as String).toList(growable: false) as T;
    }
    return null;
  }

  Future<bool> remove(String key) {
    return preferences.remove(key);
  }
}

class _SettingsProvider extends InheritedWidget {
  const _SettingsProvider({
    required Widget child,
    required this.instance,
    required this.initiating,
  }) : super(child: child);
  final Settings? instance;
  final bool initiating;

  @override
  bool updateShouldNotify(covariant _SettingsProvider oldWidget) {
    return instance != oldWidget.instance || initiating != initiating;
  }
}
