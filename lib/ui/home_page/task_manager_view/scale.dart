import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class Scale extends StatefulWidget {
  const Scale({
    super.key,
    required this.child,
    required this.constraints,
    required this.enable,
  });
  final Widget child;
  final bool enable;
  final BoxConstraints constraints;

  @override
  State<Scale> createState() => _ScaleState();
}

class _ScaleState extends State<Scale> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: widget.enable ? 1 : 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant Scale oldWidget) {
    if (widget.enable != oldWidget.enable) {
      _controller.animateTo(widget.enable ? 1 : 0,
          curve: Curves.ease, duration: const Duration(milliseconds: 450));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Tween<double>(begin: 1, end: 0.9).evaluate(_controller);
    return ImageFiltered(
      imageFilter: ImageFilter.matrix(_scale(s)),
      child: widget.child,
    );
  }

  Float64List _scale(double scale) {
    final f = (1 - scale) / 2;
    return Float64List.fromList([
      scale, 0, 0, 0, //
      0, scale, 0, 0, //
      0, 0, 1, 0, //
      widget.constraints.maxWidth * f, widget.constraints.maxHeight * f, 0,
      1, //
    ]);
  }
}
