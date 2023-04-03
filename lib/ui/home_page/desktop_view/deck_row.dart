import 'package:flutter/material.dart' hide DragTarget;
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/home_page/app_icon.dart';
import 'package:my_web/ui/widgets/drag_target.dart';

import 're_layout.dart';

class DeckRow extends StatelessWidget {
  const DeckRow({super.key, required this.data});
  final List<AppData> data;

  @override
  Widget build(BuildContext context) {
    Offset? getTargetPosition() {
      if (context.mounted) {
        final obj = context.findRenderObject();
        if (obj is RenderBox) {
          return obj.localToGlobal(Offset.zero);
        }
      }
      return null;
    }

    void onDragStart(AppData appData, DragAvatar avatar) {
      final index = data.indexOf(appData);
      if (index != -1) {
        context
            .dependOnInheritedWidgetOfExactType<ReLayoutData>()
            ?.startDrag(ReLayoutDragPositionData.fromDeck(
              appData,
              avatar,
              index,
              getTargetPosition,
            ));
      }
    }

    return ReLayoutOnDragStartData(
      onDragStart: onDragStart,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: _children(
            context,
            constraints,
            getTargetPosition,
          ).toList(growable: false),
        );
      }),
    );
  }

  Iterable<Widget> _children(
    BuildContext context,
    BoxConstraints constraints,
    Offset? Function() getTargetPosition,
  ) sync* {
    final theme = Theme.of(context);
    final reLayout =
        context.dependOnInheritedWidgetOfExactType<ReLayoutData>()!;
    final positionData = reLayout.positionData;
    if (positionData is ReLayoutDragPositionData) {
      final data =
          this.data.where((element) => element != positionData.appData);
      final dragTargetIndex = positionData.deckPosition;
      final columns = data.length + (dragTargetIndex == null ? 0 : 1);
      final double width = 64 * columns + 16 * (columns + 1);
      final left = (constraints.maxWidth - width) / 2;
      yield AnimatedPositioned(
        duration: const Duration(milliseconds: 450),
        curve: Curves.ease,
        top: 8,
        left: left,
        width: width,
        height: constraints.maxHeight - 16,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.38),
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          child: const Center(),
        ),
      );

      final top = (constraints.maxHeight - 64) / 2;
      var iconLeft = left + 16;
      var index = 0;
      for (final d in data) {
        final shifted =
            dragTargetIndex == null ? false : index >= dragTargetIndex;
        yield AnimatedPositioned(
          key: ValueKey(d),
          duration: const Duration(milliseconds: 450),
          curve: Curves.ease,
          left: shifted ? iconLeft + (64 + 16) : iconLeft,
          top: top,
          width: 64,
          height: 64,
          child: AppIcon(data: d, label: false),
        );
        ++index;
        iconLeft += (64 + 16);
      }
      //
      yield* _dragTargets(
        left,
        columns,
        reLayout,
        positionData,
        dragTargetIndex,
        getTargetPosition,
      );
    } else {
      final len = data.length;
      final double width = 64 * len + 16 * (len + 1);
      final left = (constraints.maxWidth - width) / 2;
      yield AnimatedPositioned(
        duration: const Duration(milliseconds: 450),
        curve: Curves.ease,
        top: 8,
        left: left,
        width: width,
        height: constraints.maxHeight - 16,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.38),
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          child: const Center(),
        ),
      );

      if (positionData is ReLayoutFlyBackPositionData &&
          positionData.positionData.deckPosition != null) {
        final startRect = Rect.fromLTWH(
          positionData.shift.dx,
          positionData.shift.dy,
          positionData.size.width,
          positionData.size.height,
        );
        var endRect = startRect;
        final top = (constraints.maxHeight - 64) / 2;
        var iconLeft = left + 16;
        for (final d in data) {
          if (d != positionData.appData) {
            yield AnimatedPositioned(
              key: ValueKey(d),
              duration: const Duration(milliseconds: 450),
              curve: Curves.ease,
              left: iconLeft,
              top: top,
              width: 64,
              height: 64,
              child: AppIcon(data: d, label: false),
            );
          } else {
            endRect = Rect.fromLTWH(iconLeft, top, 64, 64);
          }

          iconLeft += (64 + 16);
        }
        yield AnimatedBuilder(
          animation: reLayout.animation,
          builder: (context, child) {
            return Positioned.fromRect(
              rect: Rect.lerp(
                startRect,
                endRect,
                Curves.linearToEaseOut.transform(reLayout.animation.value),
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
              labelEndOpacity: 0,
              text: FloatingIcon.createText(context, positionData.appData.name),
            ),
          ),
        );
      } else {
        final top = (constraints.maxHeight - 64) / 2;
        var iconLeft = left + 16;
        for (final d in data) {
          yield AnimatedPositioned(
            key: ValueKey(d),
            duration: const Duration(milliseconds: 450),
            curve: Curves.ease,
            left: iconLeft,
            top: top,
            width: 64,
            height: 64,
            child: AppIcon(data: d, label: false),
          );
          iconLeft += (64 + 16);
        }
      }
    }
  }

  Iterable<Widget> _dragTargets(
    double left,
    int columns,
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
          reLayout
              .updateDragData(positionData.toDeck(index, getTargetPosition));
          return true;
        },
      );
    }

    var index = 0;
    const double width = (16 + 64);
    const double leftWidth = 32 + 16;
    yield Positioned(
      left: left,
      top: 0,
      bottom: 0,
      width: leftWidth,
      child: itemBuilder((dragTargetIndex != null && index < dragTargetIndex)
          ? index
          : index + 1),
    );
    left += leftWidth;
    ++index;
    for (var colIndex = 0; colIndex < columns - 1; colIndex++) {
      yield Positioned(
        left: left,
        top: 0,
        bottom: 0,
        width: width,
        child: itemBuilder(index),
      );
      left += width;
      ++index;
    }
    yield Positioned(
      left: left,
      top: 0,
      bottom: 0,
      width: leftWidth,
      child: itemBuilder((dragTargetIndex == null || index > dragTargetIndex)
          ? index
          : index - 1),
    );
  }
}
