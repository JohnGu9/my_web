import 'dart:math';

import 'package:flutter/material.dart';

class StackListViewData<T> {
  double sizeFactor;
  final Key key;
  final T data;

  StackListViewData(this.sizeFactor, this.key, this.data);
}

class StackListView<T> extends StatefulWidget {
  const StackListView({
    super.key,
    required this.constraints,
    required this.itemBuilder,
    required this.controller,
    required this.stack,
    required this.stackDuration,
    required this.isScrollEnable,
    required this.data,
  });
  final BoxConstraints constraints;
  final Widget Function(BuildContext, double delta, int index, T data)
      itemBuilder;
  final List<StackListViewData<T>> data;
  final ScrollController controller;
  final bool stack;
  final Duration stackDuration;
  final bool isScrollEnable;

  @override
  State<StackListView> createState() => _StackListViewState<T>();
}

class _StackListViewState<T> extends State<StackListView<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get _scrollPosition {
    if (widget.controller.hasClients) {
      return widget.controller.offset -
          widget.controller.position.minScrollExtent;
    }
    return widget.controller.initialScrollOffset;
  }

  _update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _controller.animateTo(
      widget.stack ? 1 : 0,
      duration: widget.stackDuration,
      curve: Curves.linearToEaseOut,
    );
    widget.controller.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant StackListView<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }
    if (oldWidget.stack != widget.stack) {
      _controller.animateTo(
        widget.stack ? 1 : 0,
        duration: widget.stackDuration,
        curve: Curves.linearToEaseOut,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.constraints.maxWidth;
    final scrollPosition = _scrollPosition / width;
    final itemCount = widget.data.length;
    var allSizeFactor = 0.0;
    Widget itemBuilder(int index) {
      final thisData = widget.data[index];
      final delta = scrollPosition - allSizeFactor;
      allSizeFactor += (thisData.sizeFactor + 1.0);
      if (delta >= 1.5 || delta < -3) {
        return SizedBox.fromSize(
          size: widget.constraints.biggest,
        );
      }
      final shift = exp(delta) - 1;
      final offset =
          Tween<double>(begin: delta, end: shift / 4).evaluate(_controller);
      final scale =
          Tween<double>(begin: 1, end: 1 + delta / 40).evaluate(_controller);
      return SizedBox.fromSize(
        key: thisData.key,
        size: widget.constraints.biggest,
        child: FractionalTranslation(
          translation: Offset(offset, thisData.sizeFactor),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: widget.itemBuilder(context, delta, index, thisData.data),
          ),
        ),
      );
    }

    final child = Stack(
      children: [
        for (var index = 0; index < itemCount; index++) itemBuilder(index),
      ].reversed.toList(growable: false),
    );
    return CustomScrollView(
      controller: widget.controller,
      physics: widget.isScrollEnable
          ? const PageScrollPhysics(parent: BouncingScrollPhysics())
          : const NeverScrollableScrollPhysics(
              parent: PageScrollPhysics(parent: BouncingScrollPhysics())),
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      reverse: true,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _P(
            extent: width,
            child: child,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            width: max((allSizeFactor - 1), 0) * width,
          ),
        ),
      ],
    );
  }
}

class _P extends SliverPersistentHeaderDelegate {
  const _P({required double extent, required this.child})
      : maxExtent = extent,
        minExtent = extent;

  final Widget child;

  @override
  final double maxExtent;

  @override
  final double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _P oldDelegate) {
    return child != oldDelegate.child;
  }
}
