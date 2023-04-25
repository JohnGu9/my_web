import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final _background = SvgPicture.asset(
  "assets/background.svg",
  fit: BoxFit.cover,
  placeholderBuilder: _placeholderBuilder,
);

class DesktopBackground extends StatelessWidget {
  const DesktopBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _background,
        ),
        Positioned.fill(
          child: DesktopBackgroundData(
            background: _background,
            child: child,
          ),
        ),
      ],
    );
  }
}

class DesktopBackgroundData extends InheritedWidget {
  const DesktopBackgroundData({
    super.key,
    required this.background,
    required super.child,
  });
  final Widget background;

  @override
  bool updateShouldNotify(covariant DesktopBackgroundData oldWidget) {
    return oldWidget.background != background;
  }
}

Widget _placeholderBuilder(BuildContext context) {
  return Container(
    color: const Color.fromRGBO(81, 46, 95, 1),
  );
}
