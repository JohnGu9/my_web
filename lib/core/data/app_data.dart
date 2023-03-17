import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppData {
  AppData({
    required this.name,
    required this.icon,
    required this.iconBackground,
    required this.app,
  });

  final String name;
  final Widget icon;
  final Widget iconBackground;
  final Widget app;

  final GlobalKey iconKey = GlobalKey();
  final GlobalKey appKey = GlobalKey();

  final snapshot = ValueNotifier<ui.Image?>(null);
  Future<void> updateSnapshot() async {
    try {
      final obj = appKey.currentContext?.findRenderObject();
      if (obj is RenderRepaintBoundary) {
        snapshot.value = await obj.toImage();
      }
    } catch (_) {}
  }
}
