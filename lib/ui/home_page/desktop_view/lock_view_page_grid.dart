import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';

class LockViewPageGrid extends StatelessWidget {
  const LockViewPageGrid({
    super.key,
    required this.animation,
    required this.data,
    required this.rows,
    required this.columns,
  });
  final Animation<double> animation;
  final List<AppData> data;
  final int rows;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final tween = Tween<double>(begin: 1, end: 0);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutExpo,
    );
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / columns;
          final height = constraints.maxHeight / rows;
          return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final value = tween.evaluate(curvedAnimation);
                return Stack(
                  children: animation.isDismissed
                      ? const []
                      : _children(
                          context,
                          constraints,
                          width,
                          height,
                          value,
                        ).toList(growable: false),
                );
              });
        },
      ),
    );
  }

  Iterable<Widget> _children(
    BuildContext context,
    BoxConstraints constraints,
    double width,
    double height,
    double animation,
  ) sync* {
    var index = 0;
    var top = 0.0;
    const rowCenter = 2;
    final columnCenter = columns / 2;
    final standardDistance = Offset(width, height).distance;
    final factor = 2 *
        Offset(constraints.maxWidth, constraints.maxHeight).distance /
        standardDistance;
    for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
      var left = 0.0;
      for (var colIndex = 0; colIndex < columns; colIndex++) {
        if (index == data.length) return;
        final d = data[index];
        final alignment = Alignment(
          (columnCenter * 2 - 1) - colIndex * 2,
          (rowCenter * 2 - 1) - rowIndex * 2,
        );
        final distance =
            Offset(alignment.x * width, alignment.y * height).distance /
                standardDistance;
        final scale = 1.0 + (factor * distance * animation);
        yield Positioned.fromRect(
          key: ValueKey(d),
          rect: Rect.fromLTWH(left, top, width, height),
          child: Transform.scale(
            alignment: alignment,
            scale: scale,
            child: Center(
              child: _SimpleAppIcon(data: d),
            ),
          ),
        );
        ++index;
        left += width;
      }
      top += height;
    }
  }
}

class _SimpleAppIcon extends StatelessWidget {
  const _SimpleAppIcon({required this.data});
  final AppData data;

  @override
  Widget build(BuildContext context) {
    final text = FloatingIcon.createText(context, data.name);

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: -20,
            child: Center(child: text),
          ),
          Positioned.fill(
            child: Material(
              elevation: 2,
              animationDuration: Duration.zero,
              borderRadius: AppIcon.borderRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(child: data.iconBackground),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: data.icon,
                    ),
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
