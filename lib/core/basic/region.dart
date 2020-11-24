import 'package:flutter/material.dart';

class Region {
  final double height;
  final double left;
  final double top;
  final double width;

  const Region({
    this.top,
    this.left,
    this.height,
    this.width,
  });

  const Region.fromZero({
    this.top = 0,
    this.left = 0,
    this.height = 0,
    this.width = 0,
  });

  factory Region.fromContext(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox == null) return null;
    final position = renderBox.localToGlobal(Offset.zero);
    return Region(
      left: position.dx,
      top: position.dy,
      width: renderBox.size.width,
      height: renderBox.size.height,
    );
  }

  Size get size {
    return Size(width, height);
  }

  Region copyWith({
    final double height,
    final double left,
    final double top,
    final double width,
  }) {
    return Region(
      height: height ?? this.height,
      width: width ?? this.width,
      top: top ?? this.top,
      left: left ?? this.left,
    );
  }

  Region padding({
    final double right = 0,
    final double left = 0,
    final double top = 0,
    final double bottom = 0,
  }) {
    return Region(
      height: this.height - top - bottom,
      width: this.width - left - right,
      top: this.top + top,
      left: this.left + left,
    );
  }

  Region operator +(Region other) {
    return Region(
      top: top + other.top,
      left: left + other.left,
      width: width + other.width,
      height: height + other.height,
    );
  }

  Region operator -(Region other) {
    return Region(
      top: top - other.top,
      left: left - other.left,
      width: width - other.width,
      height: height - other.height,
    );
  }

  Region operator *(num other) {
    return Region(
      top: top * other,
      left: left * other,
      width: width * other,
      height: height * other,
    );
  }

  operator ==(Object other) {
    if (other is Region) {
      if (top == other.top &&
          left == other.left &&
          width == other.width &&
          height == other.height) return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'Region [left=$left top=$top width=$width height=$height]';
  }

  @override
  int get hashCode => super.hashCode;
}
