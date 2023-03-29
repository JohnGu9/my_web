import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/drag_target.dart';

class ReLayout extends StatefulWidget {
  const ReLayout({super.key, required this.child, required this.data});
  final Widget child;
  final ReLayoutOrderData data;

  @override
  State<ReLayout> createState() => _ReLayoutState();
}

class _ReLayoutState extends State<ReLayout>
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  ReLayoutPositionData? _positionData;
  late AnimationController _controller;

  void _startDrag(ReLayoutDragPositionData positionData) {
    _controller.value = 0;
    setState(() {
      final last = widget.data.pagesData.last;
      if (!(last.length == 1 && last[0] == positionData.appData)) {
        widget.data.pagesData.add([]);
      }
      _positionData = positionData;
    });
  }

  void _updateDragData(ReLayoutDragPositionData positionData) {
    setState(() {
      _positionData = positionData;
    });
  }

  void _submit() {
    final positionData = _positionData;
    if (positionData is ReLayoutDragPositionData) {
      final renderObject = _key.currentContext?.findRenderObject();
      final targetPosition = positionData.getTargetPosition();
      if (renderObject is RenderBox && targetPosition != null) {
        final origin = positionData._origin;
        if (origin is _ReLayoutDeckPositionData) {
          widget.data.deckData.removeAt(origin.position);
        } else if (origin is _ReLayoutPagePositionData) {
          widget.data.pagesData[origin.pageIndex].removeAt(origin.position);
        }

        ReLayoutDragPositionData? data;
        if (positionData is _ReLayoutDeckPositionData) {
          final list = widget.data.deckData;
          list.insert(
            min(positionData.position, list.length),
            positionData.appData,
          );
          widget.data.pagesData.removeWhere((element) => element.isEmpty);
        } else if (positionData is _ReLayoutPagePositionData) {
          final list = widget.data.pagesData[positionData.pageIndex];
          list.insert(
            min(positionData.position, list.length),
            positionData.appData,
          );
          widget.data.pagesData.removeWhere((element) => element.isEmpty);
          final currentIndex = widget.data.pagesData.indexOf(list);
          if (currentIndex != positionData.pageIndex) {
            data = positionData.toPage(currentIndex, positionData.position,
                positionData.getTargetPosition);
          }
        }

        final position = renderObject.localToGlobal(Offset.zero);
        _controller.animateTo(1);
        setState(() {
          _positionData = ReLayoutFlyBackPositionData(
            data ?? positionData,
            position - targetPosition,
            renderObject.size,
          );
        });
      } else {
        widget.data.pagesData.removeWhere((element) => element.isEmpty);
        setState(() {
          _positionData = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.data.pagesData.removeWhere((element) => element.isEmpty);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450))
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            setState(() {
              _positionData = null;
            });
            break;
          default:
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReLayoutData(
      orderData: widget.data,
      feedbackKey: _key,
      positionData: _positionData,
      animation: _controller,
      startDrag: _startDrag,
      updateDragData: _updateDragData,
      submit: _submit,
      child: widget.child,
    );
  }
}

class ReLayoutData extends InheritedWidget {
  const ReLayoutData({
    super.key,
    required super.child,
    required this.orderData,
    required this.feedbackKey,
    required this.positionData,
    required this.animation,
    required this.startDrag,
    required this.updateDragData,
    required this.submit,
  });
  final GlobalKey feedbackKey;
  final ReLayoutOrderData orderData;
  final ReLayoutPositionData? positionData;
  final Animation<double> animation;
  final void Function(ReLayoutDragPositionData data) startDrag;
  final void Function(ReLayoutDragPositionData data) updateDragData;
  final void Function() submit;

  @override
  bool updateShouldNotify(covariant ReLayoutData oldWidget) {
    return positionData != oldWidget.positionData;
  }
}

class ReLayoutOnDragStartData extends InheritedWidget {
  const ReLayoutOnDragStartData({
    super.key,
    required super.child,
    required this.onDragStart,
  });
  final void Function(AppData appData, DragAvatar avatar) onDragStart;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class ReLayoutOrderData {
  const ReLayoutOrderData(this.pagesData, this.deckData);

  final List<List<AppData>> pagesData;
  final List<AppData> deckData;
}

abstract class ReLayoutPositionData {
  const ReLayoutPositionData(this.appData);
  final AppData appData;
}

class ReLayoutFlyBackPositionData extends ReLayoutPositionData {
  ReLayoutFlyBackPositionData(this.positionData, this.shift, this.size)
      : super(positionData.appData);
  final ReLayoutDragPositionData positionData;
  final Offset shift;
  final Size size;
}

abstract class ReLayoutDragPositionData extends ReLayoutPositionData {
  ReLayoutDragPositionData._(
      super.appData, this.getTargetPosition, this.avatar);

  factory ReLayoutDragPositionData.fromPage(AppData appData, DragAvatar avatar,
      int pageIndex, int position, Offset? Function() getTargetPosition) {
    final result = _ReLayoutPagePositionData(
        appData, getTargetPosition, avatar, pageIndex, position);
    result._origin = _ReLayoutPagePositionData(
        appData, getTargetPosition, avatar, pageIndex, position);
    return result;
  }

  factory ReLayoutDragPositionData.fromDeck(AppData appData, DragAvatar avatar,
      int position, Offset? Function() getTargetPosition) {
    final result =
        _ReLayoutDeckPositionData(appData, getTargetPosition, avatar, position);
    result._origin =
        _ReLayoutDeckPositionData(appData, getTargetPosition, avatar, position);
    return result;
  }

  final Offset? Function() getTargetPosition;
  final DragAvatar avatar;

  int? getPagePosition(int pageIndex) {
    return null;
  }

  int? get deckPosition => null;

  ReLayoutDragPositionData toPage(
      int pageIndex, int position, Offset? Function() getTargetPosition) {
    final result = _ReLayoutPagePositionData(
        appData, getTargetPosition, avatar, pageIndex, position);
    result._origin = _origin;
    return result;
  }

  ReLayoutDragPositionData toDeck(
      int position, Offset? Function() getTargetPosition) {
    final result =
        _ReLayoutDeckPositionData(appData, getTargetPosition, avatar, position);
    result._origin = _origin;
    return result;
  }

  late ReLayoutDragPositionData _origin;
}

class _ReLayoutPagePositionData extends ReLayoutDragPositionData {
  _ReLayoutPagePositionData(
    super.appData,
    super.getTargetPosition,
    super.avatar,
    this.pageIndex,
    this.position,
  ) : super._();
  final int pageIndex;
  final int position;

  @override
  int? getPagePosition(int pageIndex) {
    if (pageIndex == this.pageIndex) {
      return position;
    }
    return null;
  }
}

class _ReLayoutDeckPositionData extends ReLayoutDragPositionData {
  _ReLayoutDeckPositionData(
    super.appData,
    super.getTargetPosition,
    super.avatar,
    this.position,
  ) : super._();
  final int position;

  @override
  int? get deckPosition => position;
}
