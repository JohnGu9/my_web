import 'package:flutter/material.dart';

class DragBar extends StatelessWidget {
  const DragBar({super.key, required this.show});
  final bool show;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Jump(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedOpacity(
          opacity: show ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: theme.iconTheme.color,
            shape: const StadiumBorder(),
            child: const SizedBox(
              height: 4,
              width: 128,
            ),
          ),
        ),
      ),
    );
  }
}

class _Jump extends StatefulWidget {
  const _Jump({required this.child});
  final Widget child;

  @override
  State<_Jump> createState() => _JumpState();
}

class _JumpState extends State<_Jump> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (!_controller.isAnimating) {
          await _controller.animateTo(
            1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          _controller.animateBack(
            0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.bounceOut,
          );
        }
      },
      child: SlideTransition(
        position: Tween(
          begin: Offset.zero,
          end: const Offset(0, -0.2),
        ).animate(_controller),
        child: widget.child,
      ),
    );
  }
}
