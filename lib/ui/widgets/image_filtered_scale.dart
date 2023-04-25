import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImageFilteredScale extends StatelessWidget {
  const ImageFilteredScale(
      {super.key,
      required this.child,
      required this.constraints,
      required this.scale});
  final Widget child;
  final BoxConstraints constraints;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.matrix(_scale(scale, constraints)),
      child: child,
    );
  }
}

class ImageFilteredScaleTransition extends StatelessWidget {
  const ImageFilteredScaleTransition(
      {super.key,
      required this.child,
      required this.constraints,
      required this.scale});
  final Widget child;
  final BoxConstraints constraints;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scale,
      builder: (context, _) {
        return ImageFiltered(
          imageFilter: ImageFilter.matrix(_scale(scale.value, constraints)),
          child: child,
        );
      },
    );
  }
}

Float64List _scale(double scale, BoxConstraints constraints) {
  final f = (1 - scale) / 2;
  return Float64List.fromList([
    scale, 0, 0, 0, //
    0, scale, 0, 0, //
    0, 0, 1, 0, //
    constraints.maxWidth * f, constraints.maxHeight * f, 0,
    1, //
  ]);
}
