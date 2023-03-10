import 'dart:ui';

import 'package:flutter/material.dart';

class Blur extends StatefulWidget {
  const Blur({super.key, required this.enable});
  final bool enable;

  @override
  State<Blur> createState() => _BlurState();
}

class _BlurState extends State<Blur> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant Blur oldWidget) {
    if (widget.enable != oldWidget.enable) {
      _controller.animateTo(widget.enable ? 1 : 0,
          duration: const Duration(milliseconds: 350));
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
    final value = _controller.value;
    final sigma = 20.0 * value;
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: sigma,
        sigmaY: sigma,
      ),
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withOpacity(value * 0.12),
          child: const Center(),
        ),
      ),
    );
  }
}
