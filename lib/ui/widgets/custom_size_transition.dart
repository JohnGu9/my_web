import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomSizeTransition extends SizeTransition {
  CustomSizeTransition({
    Key key,
    Axis axis = Axis.vertical,
    @required Animation<double> sizeFactor,
    double axisAlignment = 0.0,
    Widget child,
    this.crossAxisAlignment = 0.0,
  }) : super(
            key: key,
            child: child,
            sizeFactor: sizeFactor,
            axis: axis,
            axisAlignment: axisAlignment);

  final double crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    AlignmentDirectional alignment;
    if (axis == Axis.vertical)
      alignment = AlignmentDirectional(crossAxisAlignment, axisAlignment);
    else
      alignment = AlignmentDirectional(axisAlignment, crossAxisAlignment);
    return ClipRect(
      child: Align(
        alignment: alignment,
        heightFactor:
            axis == Axis.vertical ? math.max(sizeFactor.value, 0.0) : null,
        widthFactor:
            axis == Axis.horizontal ? math.max(sizeFactor.value, 0.0) : null,
        child: child,
      ),
    );
  }
}
