import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class ReLayout extends StatefulWidget {
  const ReLayout({super.key, required this.child, required this.data});
  final Widget child;
  final ReLayoutOrderData data;

  @override
  State<ReLayout> createState() => _ReLayoutState();
}

class _ReLayoutState extends State<ReLayout> {
  final _key = GlobalKey();
  ReLayoutPositionData? _positionData;

  void _startDrag(ReLayoutDragPositionData positionData) {
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
        final position = renderObject.localToGlobal(Offset.zero);
        setState(() {
          _positionData = ReLayoutFlyBackPositionData(
            positionData,
            position - targetPosition,
            renderObject.size,
          );
        });

        final origin = positionData._origin;
        if (origin is _ReLayoutDeckPositionData) {
          widget.data.deckData.removeAt(origin.position);
        } else if (origin is _ReLayoutPagePositionData) {
          widget.data.pagesData[origin.pageIndex].removeAt(origin.position);
        }

        if (positionData is _ReLayoutDeckPositionData) {
          final list = widget.data.deckData;
          list.insert(
            min(positionData.position, list.length),
            positionData.appData,
          );
        } else if (positionData is _ReLayoutPagePositionData) {
          final list = widget.data.pagesData[positionData.pageIndex];
          list.insert(
            min(positionData.position, list.length),
            positionData.appData,
          );
        }
      } else {
        setState(() {
          _positionData = null;
        });
      }
      widget.data.pagesData.removeWhere((element) => element.isEmpty);
    }
  }

  _clear() {
    setState(() {
      _positionData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReLayoutData(
      orderData: widget.data,
      feedbackKey: _key,
      positionData: _positionData,
      startDrag: _startDrag,
      updateDragData: _updateDragData,
      submit: _submit,
      clear: _clear,
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
    required this.startDrag,
    required this.updateDragData,
    required this.submit,
    required this.clear,
  });
  final GlobalKey feedbackKey;
  final ReLayoutOrderData orderData;
  final ReLayoutPositionData? positionData;
  final void Function(ReLayoutDragPositionData data) startDrag;
  final void Function(ReLayoutDragPositionData data) updateDragData;
  final void Function() submit;
  final void Function() clear;

  @override
  bool updateShouldNotify(covariant ReLayoutData oldWidget) {
    return positionData != oldWidget.positionData;
  }
}

class ReLayoutOnDragStartData extends InheritedWidget {
  const ReLayoutOnDragStartData(
      {super.key, required super.child, required this.onDragStart});
  final void Function(AppData appData) onDragStart;

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
  ReLayoutDragPositionData._(super.appData, this.getTargetPosition);

  factory ReLayoutDragPositionData.fromPage(AppData appData, int pageIndex,
      int position, Offset? Function() getTargetPosition) {
    final result = _ReLayoutPagePositionData(
        appData, getTargetPosition, pageIndex, position);
    result._origin = _ReLayoutPagePositionData(
        appData, getTargetPosition, pageIndex, position);
    return result;
  }

  factory ReLayoutDragPositionData.fromDeck(
      AppData appData, int position, Offset? Function() getTargetPosition) {
    final result =
        _ReLayoutDeckPositionData(appData, getTargetPosition, position);
    result._origin =
        _ReLayoutDeckPositionData(appData, getTargetPosition, position);
    return result;
  }

  final Offset? Function() getTargetPosition;

  int? getPagePosition(int pageIndex) {
    return null;
  }

  int? get deckPosition => null;

  ReLayoutDragPositionData toPage(
      int pageIndex, int position, Offset? Function() getTargetPosition) {
    final result = _ReLayoutPagePositionData(
        appData, getTargetPosition, pageIndex, position);
    result._origin = _origin;
    return result;
  }

  ReLayoutDragPositionData toDeck(
      int position, Offset? Function() getTargetPosition) {
    final result =
        _ReLayoutDeckPositionData(appData, getTargetPosition, position);
    result._origin = _origin;
    return result;
  }

  late ReLayoutDragPositionData _origin;
}

class _ReLayoutPagePositionData extends ReLayoutDragPositionData {
  _ReLayoutPagePositionData(
    AppData appData,
    Offset? Function() getTargetPosition,
    this.pageIndex,
    this.position,
  ) : super._(appData, getTargetPosition);
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
    AppData appData,
    Offset? Function() getTargetPosition,
    this.position,
  ) : super._(appData, getTargetPosition);
  final int position;

  @override
  int? get deckPosition => position;
}
