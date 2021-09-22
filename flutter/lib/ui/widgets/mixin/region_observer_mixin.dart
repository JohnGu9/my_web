import 'package:flutter/material.dart';
import 'package:my_web/core/basic/region.dart';

mixin RegionObserverMixin<T extends StatefulWidget> on State<T> {
  ValueNotifier<Region?> get region;
  ValueNotifier<bool> get visibility;

  void hide() {
    visibility.value = false;
  }

  void show() {
    visibility.value = true;
  }

  Region updateRegion() {
    if (mounted) {
      final newRegion = Region.fromContext(context);
      if (newRegion != null) region.value = newRegion;
    }
    return region.value!;
  }
}
