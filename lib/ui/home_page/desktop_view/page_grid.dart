import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';
import 'package:my_web/ui/home_page/desktop_view/fly_back_positioned.dart';
import 'package:my_web/ui/home_page/desktop_view/re_layout.dart';

import 'touch_protect.dart';

class PageGrid extends StatelessWidget {
  const PageGrid({
    super.key,
    required this.rows,
    required this.columns,
    required this.data,
    required this.pageIndex,
  });
  final List<AppData> data;
  final int rows;
  final int columns;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final enable =
        context.dependOnInheritedWidgetOfExactType<TouchProtectData>()?.enable;
    final reLayout = context.dependOnInheritedWidgetOfExactType<ReLayoutData>();
    Offset? getTargetPosition() {
      if (context.mounted) {
        final obj = context.findRenderObject();
        if (obj is RenderBox) {
          return obj.localToGlobal(Offset.zero);
        }
      }
      return null;
    }

    void onDragStart(AppData appData) {
      final index = data.indexOf(appData);
      if (index != -1) {
        context
            .dependOnInheritedWidgetOfExactType<ReLayoutData>()
            ?.startDrag(ReLayoutDragPositionData.fromPage(
              appData,
              pageIndex,
              index,
              getTargetPosition,
            ));
      }
    }

    return IgnorePointer(
      ignoring: enable == false,
      child: ReLayoutOnDragStartData(
        onDragStart: onDragStart,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth / columns;
            final height = constraints.maxHeight / rows;
            final children = _children(
              context,
              width,
              height,
              reLayout,
              getTargetPosition,
            );
            return Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                if (children.isNotEmpty) ...children,
              ],
            );
          },
        ),
      ),
    );
  }

  Iterable<Widget> _children(
    BuildContext context,
    double width,
    double height,
    ReLayoutData? reLayout,
    Offset? Function() getTargetPosition,
  ) sync* {
    final positionData = reLayout?.positionData;
    if (positionData is ReLayoutDragPositionData) {
      final dragTargetIndex = positionData.getPagePosition(pageIndex);
      final data = this
          .data
          .where((element) => element != positionData.appData)
          .toList(growable: false);
      yield* _reLayoutChildren(data, width, height, reLayout!, dragTargetIndex);
      yield* _dragTargets(
        width,
        height,
        reLayout,
        positionData,
        dragTargetIndex,
        getTargetPosition,
      );
    } else {
      if (positionData is ReLayoutFlyBackPositionData &&
          positionData.positionData.getPagePosition(pageIndex) != null) {
        final startRect = Rect.fromLTWH(
          positionData.shift.dx,
          positionData.shift.dy,
          positionData.size.width,
          positionData.size.height,
        );
        var endRect = startRect;
        var index = 0;
        var top = 0.0;
        for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
          var left = 0.0;
          for (var colIndex = 0; colIndex < columns; colIndex++) {
            if (index == data.length) break;
            final d = data[index];
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
          if (index == data.length) break;
          top += height;
        }
        yield FlyBackPositioned(
          key: const ValueKey(0),
          start: startRect,
          end: endRect,
          onEnd: () {
            reLayout?.clear();
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
        for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
          var left = 0.0;
          for (var colIndex = 0; colIndex < columns; colIndex++) {
            if (index == data.length) return;
            final d = data[index];
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
    final columns = this.columns - 1;
    var index = 0;
    var top = 0.0;
    for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
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
          return const Center();
        },
        onWillAccept: (data) {
          reLayout.updateDragData(
              positionData.toPage(pageIndex, index, getTargetPosition));
          return true;
        },
      );
    }

    final halfWidth = width / 2;
    var index = 0;
    var top = 0.0;
    for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
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
      for (var colIndex = 0; colIndex < columns - 1; colIndex++) {
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
