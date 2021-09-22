import 'package:flutter/material.dart';
import 'package:my_web/core/core.dart';

class RegionPositioned extends StatelessWidget {
  const RegionPositioned({
    Key? key,
    required this.region,
    required this.child,
  }) : super(key: key);

  final Region region;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: child,
      top: region.top,
      left: region.left,
      height: region.height,
      width: region.width,
    );
  }
}

class AnimatedRegionPositioned extends AnimatedWidget {
  const AnimatedRegionPositioned({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Animation<Region> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RegionPositioned(
      region: animation.value,
      child: child,
    );
  }
}
