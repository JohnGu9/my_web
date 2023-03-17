import 'package:flutter/material.dart';

extension BoxConstraintsExtension on BoxConstraints {
  Rect toRect({
    double left = 0.0,
    double top = 0.0,
    double? width,
    double? height,
  }) {
    return Rect.fromLTWH(left, top, width ?? maxWidth, height ?? maxHeight);
  }
}
