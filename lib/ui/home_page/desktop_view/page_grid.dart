import 'package:flutter/material.dart' hide DragTarget;
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';
import 'package:my_web/ui/widgets/drag_target.dart';

import 're_layout.dart';

class PageGrid extends StatefulWidget {
  const PageGrid({
    super.key,
    required this.rows,
    required this.columns,
    required this.data,
    required this.pageIndex,
    required this.reLayout,
  });
  final List<AppData> data;
  final int rows;
  final int columns;
  final int pageIndex;
  final ReLayoutData reLayout;

  @override
  State<PageGrid> createState() => _PageGridState();
}

class _PageGridState extends State<PageGrid> {
  Offset? _getTargetPosition() {
    if (mounted) {
      final obj = context.findRenderObject();
      if (obj is RenderBox) {
        return obj.localToGlobal(Offset.zero);
      }
    }
    return null;
  }

  void _onDragStart(AppData appData, DragAvatar avatar) {
    final index = widget.data.indexOf(appData);
    if (index != -1) {
      context
          .dependOnInheritedWidgetOfExactType<ReLayoutData>()
          ?.startDrag(ReLayoutDragPositionData.fromPage(
            appData,
            avatar,
            widget.pageIndex,
            index,
            _getTargetPosition,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    final positionData = widget.reLayout.positionData;
    if (positionData is ReLayoutDragPositionData) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          widget.reLayout.updateDragData(positionData.toPage(
            widget.pageIndex,
            widget.data.length,
            _getTargetPosition,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReLayoutOnDragStartData(
      onDragStart: _onDragStart,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / widget.columns;
          final height = constraints.maxHeight / widget.rows;

          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: _children(
              context,
              width,
              height,
              _getTargetPosition,
            ).toList(growable: false),
          );
        },
      ),
    );
  }

  Iterable<Widget> _children(
    BuildContext context,
    double width,
    double height,
    Offset? Function() getTargetPosition,
  ) sync* {
    final positionData = widget.reLayout.positionData;
    if (positionData is ReLayoutDragPositionData) {
      final dragTargetIndex = positionData.getPagePosition(widget.pageIndex);
      final data = widget.data
          .where((element) => element != positionData.appData)
          .toList(growable: false);
      yield* _reLayoutChildren(
          data, width, height, widget.reLayout, dragTargetIndex);
      yield* _dragTargets(
        width,
        height,
        widget.reLayout,
        positionData,
        dragTargetIndex,
        getTargetPosition,
      );
    } else {
      if (positionData is ReLayoutFlyBackPositionData &&
          positionData.positionData.getPagePosition(widget.pageIndex) != null) {
        final startRect = Rect.fromLTWH(
          positionData.shift.dx,
          positionData.shift.dy,
          positionData.size.width,
          positionData.size.height,
        );
        var endRect = startRect;
        var index = 0;
        var top = 0.0;
        for (var rowIndex = 0; rowIndex < widget.rows; rowIndex++) {
          var left = 0.0;
          for (var colIndex = 0; colIndex < widget.columns; colIndex++) {
            if (index == widget.data.length) break;
            final d = widget.data[index];
            if (d != positionData.appData) {
              yield AnimatedPositioned.fromRect(
                key: ValueKey(d),
                duration: const Duration(milliseconds: 450),
                curve: Curves.ease,
                rect: Rect.fromLTWH(left, top, width, height),
                child: Center(
                  child: AppIcon(data: d, label: true),
                ),
              );
            } else {
              endRect = Rect.fromLTWH(left, top, width, height);
            }
            ++index;
            left += width;
          }
          if (index == widget.data.length) break;
          top += height;
        }
        yield AnimatedBuilder(
          animation: widget.reLayout.animation,
          builder: (context, child) {
            return Positioned.fromRect(
              rect: Rect.lerp(
                startRect,
                endRect,
                Curves.linearToEaseOut
                    .transform(widget.reLayout.animation.value),
              )!,
              child: child!,
            );
          },
          child: Center(
            child: FloatingIcon(
              data: positionData.appData,
              startSize: const Size(72, 72),
              endSize: const Size(64, 64),
              labelStartOpacity: 0,
              labelEndOpacity: 1,
              text: FloatingIcon.createText(context, positionData.appData.name),
            ),
          ),
        );
      } else {
        var index = 0;
        var top = 0.0;
        for (var rowIndex = 0; rowIndex < widget.rows; rowIndex++) {
          var left = 0.0;
          for (var colIndex = 0; colIndex < widget.columns; colIndex++) {
            if (index == widget.data.length) return;
            final d = widget.data[index];
            yield AnimatedPositioned.fromRect(
              key: ValueKey(d),
              duration: const Duration(milliseconds: 450),
              curve: Curves.ease,
              rect: Rect.fromLTWH(left, top, width, height),
              child: Center(
                child: AppIcon(data: d, label: true),
              ),
            );
            ++index;
            left += width;
          }
          top += height;
        }
      }
    }
  }

  Iterable<Widget> _reLayoutChildren(
    List<AppData> data,
    double width,
    double height,
    ReLayoutData reLayout,
    int? dragTargetIndex,
  ) sync* {
    final columns = widget.columns - 1;
    var index = 0;
    var top = 0.0;
    for (var rowIndex = 0; rowIndex < widget.rows; rowIndex++) {
      var left = 0.0;
      for (var colIndex = 0; colIndex < columns; colIndex++) {
        if (index == data.length) return;
        final d = data[index];
        yield AnimatedPositioned.fromRect(
          key: ValueKey(d),
          duration: const Duration(milliseconds: 450),
          curve: Curves.ease,
          rect: (dragTargetIndex == null ? false : index >= dragTargetIndex)
              ? Rect.fromLTWH(left + width, top, width, height)
              : Rect.fromLTWH(left, top, width, height),
          child: Center(
            child: AppIcon(data: d, label: true),
          ),
        );
        ++index;
        left += width;
      }
      if (index == data.length) return;
      final d = data[index];
      yield AnimatedPositioned.fromRect(
        key: ValueKey(d),
        duration: const Duration(milliseconds: 450),
        curve: Curves.ease,
        rect: (dragTargetIndex == null ? false : index >= dragTargetIndex)
            ? Rect.fromLTWH(0, top + height, width, height)
            : Rect.fromLTWH(left, top, width, height),
        child: Center(
          child: AppIcon(data: d, label: true),
        ),
      );
      ++index;
      left += width;
      top += height;
    }
  }

  Iterable<Widget> _dragTargets(
    double width,
    double height,
    ReLayoutData reLayout,
    ReLayoutDragPositionData positionData,
    int? dragTargetIndex,
    Offset? Function() getTargetPosition,
  ) sync* {
    Widget itemBuilder(int i) {
      final index =
          (dragTargetIndex == null || i > dragTargetIndex) ? i - 1 : i;
      return DragTarget(
        builder: (context, candidateData, rejectedData) {
          // return Placeholder(
          //   color: index == dragTargetIndex ? Colors.red : Colors.blue,
          // );
          return const Center();
        },
        onWillAccept: (data) {
          reLayout.updateDragData(
              positionData.toPage(widget.pageIndex, index, getTargetPosition));
          return true;
        },
      );
    }

    final halfWidth = width / 2;
    var index = 0;
    var top = 0.0;
    for (var rowIndex = 0; rowIndex < widget.rows; rowIndex++) {
      var left = halfWidth;
      yield Positioned(
        left: 0,
        top: top,
        width: left,
        height: height,
        child: itemBuilder((dragTargetIndex != null && index < dragTargetIndex)
            ? index
            : index + 1),
      );
      ++index;
      for (var colIndex = 0; colIndex < widget.columns - 1; colIndex++) {
        yield Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: itemBuilder(index),
        );
        left += width;
        ++index;
      }
      yield Positioned(
        left: left,
        top: top,
        width: halfWidth,
        height: height,
        child: itemBuilder((dragTargetIndex == null || index > dragTargetIndex)
            ? index
            : index - 1),
      );
      top += height;
    }
  }
}
