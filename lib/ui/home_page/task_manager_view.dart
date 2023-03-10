import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/drag_gesture.dart';
import 'package:my_web/ui/widgets/stack_list_view.dart';

import 'task_manager_view/blur.dart';
import 'task_manager_view/scale.dart';
import 'task_manager_view/task_manager_app_card.dart';
import 'task_manager_view/task_manager_data.dart';

class TaskManagerView extends StatefulWidget {
  const TaskManagerView({
    super.key,
    required this.child,
    required this.constraints,
  });
  final Widget child;
  final BoxConstraints constraints;

  @override
  State<TaskManagerView> createState() => _TaskManagerViewState();
}

class _TaskManagerViewState extends State<TaskManagerView>
    with SingleTickerProviderStateMixin {
  static final _actions = {_ActionIntent: _Action()};
  late ScrollController _scrollController;
  late AnimationController _reenterController;
  late BoxConstraints _layoutConstraints;
  _TaskManagerAnimationData? _data;
  final List<StackListViewData<AppData>> _apps = [];
  AppData? _focusApp;

  Rect _getRect(RenderBox box) {
    final size = box.size;
    final offset = box.localToGlobal(
      Offset.zero,
      ancestor: context.findRenderObject(),
    );
    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
  }

  void _enter(AppData data) {
    _focusApp = data;
    final index = _apps.indexWhere((element) {
      return element.data == data;
    });
    if (index != -1) _apps.removeAt(index);
    _apps.insert(0, StackListViewData<AppData>(0, ValueKey(data), data));
    for (final app in _apps) {
      app.sizeFactor = 0;
    }

    final context = data.iconKey.currentContext;
    if (context == null) {
      _reenter(
        _data = _TaskManagerEnterAppAnimationData(
          Rect.fromLTWH(
            -widget.constraints.maxWidth,
            0,
            widget.constraints.maxWidth,
            widget.constraints.maxHeight,
          ),
          _AppRect.invalid,
        ),
      );
    } else {
      final start = context.findRenderObject() as RenderBox;
      final rect = _getRect(start);
      _reenter(_data = _TaskManagerAppFlyInAnimationData(
        _AppRect(0, rect, 1),
      ));
    }
  }

  void _reenter(_TaskManagerAnimationData _) async {
    if (_data?.isEnterApp != true && _data?.isDragging != true) {
      _focusApp?.updateSnapshot();
    }
    _reenterController.value = 0;
    await _reenterController.animateTo(1);
    if (_reenterController.isCompleted && _data?.isEnterApp == true) {
      final index = _getCurrentIndex();
      if (index > -1 && index < _apps.length) {
        final app = _apps[index];
        if (app.data != _focusApp) {
          setState(() {
            _focusApp = app.data;
          });
        }
      }
    }
  }

  void _exit(_TaskManagerAnimationData _) async {
    _focusApp?.updateSnapshot();
    _reenterController.value = 1;
    await _reenterController.animateBack(0);
    if (_reenterController.isDismissed) {
      setState(() {
        _data = null;
      });
    }
  }

  int _getCurrentIndex() {
    return (_scrollController.offset / _layoutConstraints.maxWidth).round();
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index.clamp(0, (_apps.length - 1)) * _layoutConstraints.maxWidth,
      duration: const Duration(milliseconds: 450),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _reenterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        setState(() {});
      });

    _layoutConstraints = widget.constraints.copyWith(
      maxWidth: widget.constraints.maxWidth + 32,
    );
  }

  @override
  void didUpdateWidget(covariant TaskManagerView oldWidget) {
    if (widget.constraints != oldWidget.constraints) {
      _layoutConstraints = widget.constraints.copyWith(
        maxWidth: widget.constraints.maxWidth + 32,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _reenterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data is _TaskManagerAnimationData) {
      final isEnterTaskManager = data is _TaskManagerEnterAnimationData;
      final stackListViewRect = data.toStackListViewRect(
        widget.constraints,
        _reenterController.value,
      );
      final appRect = data.toAppRect(
        widget.constraints,
        _reenterController.value,
      );
      final appData = (data.hideFromWidget &&
              appRect.index > -1 &&
              appRect.index < _apps.length)
          ? _apps[appRect.index].data
          : null;
      void exit() {
        _exit(_data = _TaskManagerExitAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      final biggest = widget.constraints.biggest;
      final otherRect = Rect.fromLTWH(
        biggest.width * (1 - appRect.other) / 2,
        biggest.height * (1 - appRect.other) / 2,
        biggest.width * appRect.other,
        biggest.height * appRect.other,
      );
      final padding = (_layoutConstraints.maxWidth - biggest.width) / 2;

      void enterTaskManager() {
        _reenter(_data = _TaskManagerEnterAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      void enterApp(int index) {
        if (index > -1 && index < _apps.length) {
          _focusApp = _apps[index].data;
        }
        _scrollToIndex(index);
        _reenter(_data = _TaskManagerEnterAppAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      void flyBack() {
        final index = _getCurrentIndex();
        final nextAppRect = _AppRect(
          index,
          appRect.index == index ? appRect.rect : otherRect,
          appRect.other,
        );
        Rect? getTargetRect() {
          if (index < _apps.length) {
            final appData = _apps[index];
            final context = appData.data.iconKey.currentContext;
            if (context != null) {
              final start = context.findRenderObject() as RenderBox;
              final rect = _getRect(start);
              return rect;
            }
          }
          return null;
        }

        final rect = getTargetRect();
        if (rect != null) {
          _exit(_data = _TaskManagerAppFlyBackAnimationData(
            stackListViewRect,
            nextAppRect,
            rect,
          ));
        } else {
          _exit(_data = _TaskManagerExitAppAnimationData(
            stackListViewRect,
            nextAppRect,
          ));
        }
      }

      return Shortcuts(
        shortcuts: data.isEnter
            ? {
                LogicalKeySet(LogicalKeyboardKey.escape): data.isEnterApp
                    ? _ActionIntent(flyBack)
                    : _ActionIntent(exit),
                LogicalKeySet(LogicalKeyboardKey.f3): data.isEnterApp
                    ? _ActionIntent(enterTaskManager)
                    : _ActionIntent(exit),
              }
            : {
                LogicalKeySet(LogicalKeyboardKey.escape):
                    _ActionIntent(enterTaskManager),
                LogicalKeySet(LogicalKeyboardKey.f3):
                    _ActionIntent(enterTaskManager),
              },
        child: Actions(
          actions: _actions,
          child: TaskManagerData(
            enter: _enter,
            appData: appData,
            duration: data.hideFromWidgetDuration,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Scale(
                    enable: data.isEnter,
                    constraints: widget.constraints,
                    child: widget.child,
                  ),
                ),
                if (data.isEnter)
                  const Positioned.fill(child: Blur(enable: true))
                else
                  const Positioned.fill(child: Blur(enable: false)),
                Positioned.fromRect(
                  rect: stackListViewRect,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox.fromSize(
                      size: _layoutConstraints.biggest,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onTap: exit,
                        child: StackListView<AppData>(
                          isScrollEnable: isEnterTaskManager,
                          stack: isEnterTaskManager,
                          stackDuration: const Duration(milliseconds: 450),
                          controller: _scrollController,
                          constraints: _layoutConstraints,
                          data: _apps,
                          itemBuilder: (context, delta, index, appData) {
                            final thisData = _apps[index];
                            final isPrimary = index == appRect.index;
                            final isFlyAnimation =
                                isPrimary ? data.isFlyAnimation : null;
                            final child = TaskManagerAppCard(
                              isFlyAnimation: isFlyAnimation,
                              appData: appData,
                              biggest: biggest,
                              delta: delta,
                              showDragBar: data.showDragBar,
                              isEnterTaskManager: isEnterTaskManager,
                              isFocus: appData == _focusApp,
                              isEnterApp: data.isEnterApp,
                              reenterEnable: data.reenterEnable,
                              reenterApp: () {
                                return enterApp(index);
                              },
                              updateSizeFactor: (value) {
                                setState(() {
                                  thisData.sizeFactor = value;
                                });
                              },
                              removeApp: () {
                                setState(() {
                                  _apps.remove(thisData);
                                });
                              },
                            );

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: padding,
                              ),
                              child: Stack(
                                children: [
                                  if (isPrimary)
                                    Positioned.fromRect(
                                      rect: appRect.rect,
                                      child: child,
                                    )
                                  else
                                    Positioned.fromRect(
                                      rect: otherRect,
                                      child: child,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 28,
                  child: DragGesture(
                    behavior: HitTestBehavior.translucent,
                    onDragUpdate: !data.isEnter
                        ? null
                        : (details) {
                            bool isLongDrag() {
                              if (data is _TaskManagerDragAppAnimationData) {
                                final now = DateTime.now();
                                final delta =
                                    now.difference(data.touchStartTime);
                                return delta >
                                    const Duration(milliseconds: 150);
                              }
                              return true;
                            }

                            bool toTaskManager(Offset shift) {
                              if (shift.dx.abs() > shift.dy.abs() * 1.5 &&
                                  isLongDrag()) {
                                return true;
                              } else if (shift.distance >
                                      widget.constraints.maxHeight / 6 &&
                                  shift.distance <
                                      widget.constraints.maxHeight / 2 &&
                                  isLongDrag()) {
                                return true;
                              } else {
                                return false;
                              }
                            }

                            if (data is _TaskManagerDragAnimationData) {
                              final shift = details.globalPosition - data.start;
                              if (toTaskManager(shift)) {
                                setState(() {
                                  _data = data.moveTo(details.globalPosition);
                                });
                              } else {
                                final index = _getCurrentIndex();
                                _reenter(
                                    _data = _TaskManagerDragAppAnimationData(
                                  data.touchStartTime,
                                  data.start,
                                  details.globalPosition,
                                  stackListViewRect,
                                  _AppRect(
                                    index,
                                    appRect.index == index
                                        ? appRect.rect
                                        : otherRect,
                                    appRect.other,
                                  ),
                                ));
                              }
                            } else if (data
                                is _TaskManagerDragAppAnimationData) {
                              final shift = details.globalPosition - data.start;
                              if (toTaskManager(shift)) {
                                final index = _getCurrentIndex();
                                _reenter(_data = _TaskManagerDragAnimationData(
                                  data.touchStartTime,
                                  data.start,
                                  details.globalPosition,
                                  stackListViewRect,
                                  _AppRect(
                                    index,
                                    appRect.index == index
                                        ? appRect.rect
                                        : otherRect,
                                    appRect.other,
                                  ),
                                ));
                              } else {
                                setState(() {
                                  _data = data.moveTo(details.globalPosition);
                                });
                              }
                            } else if (data
                                is _TaskManagerDragEnterAnimationData) {
                              setState(() {
                                _data = data.moveTo(details.globalPosition);
                              });
                            } else {
                              final current = details.globalPosition;
                              final start = Offset(
                                  current.dx,
                                  biggest.height * 2 -
                                      otherRect.height -
                                      otherRect.top);
                              final shift = current - start;
                              if (toTaskManager(shift)) {
                                _reenter(_data = _TaskManagerDragAnimationData(
                                    DateTime.now(),
                                    start,
                                    details.globalPosition,
                                    stackListViewRect,
                                    appRect));
                              } else {
                                final index = _getCurrentIndex();
                                _scrollToIndex(index);
                                _reenter(
                                    _data = _TaskManagerDragAppAnimationData(
                                  DateTime.now(),
                                  start,
                                  details.globalPosition,
                                  stackListViewRect,
                                  _AppRect(
                                    index,
                                    appRect.index == index
                                        ? appRect.rect
                                        : otherRect,
                                    appRect.other,
                                  ),
                                ));
                              }
                            }
                          },
                    onDragEnd: !data.isEnter
                        ? null
                        : (details) {
                            if (data is _Drag) {
                              final velocity = details.velocity.pixelsPerSecond;
                              if (velocity.distance < 200) {
                                // drag speed slow
                                final delta = data.current - data.start;
                                if (delta.dx.abs() > delta.dy.abs() * 1.5) {
                                  // horizontal

                                  final index =
                                      data is _TaskManagerDragEnterAnimationData
                                          ? _getCurrentIndex()
                                          : _getCurrentIndex() +
                                              (delta.dx > 0 ? 1 : -1);
                                  enterApp(index);
                                } else {
                                  // vertical
                                  if (-delta.dy <
                                      widget.constraints.maxHeight / 9) {
                                    if (data
                                        is _TaskManagerDragEnterAnimationData) {
                                      exit();
                                    } else {
                                      enterApp(_getCurrentIndex());
                                    }
                                  } else {
                                    enterTaskManager();
                                  }
                                }
                              } else {
                                // drag speed fast
                                if (velocity.dx.abs() >
                                    velocity.dy.abs() * 1.5) {
                                  // horizontal

                                  final index =
                                      data is _TaskManagerDragEnterAnimationData
                                          ? _getCurrentIndex()
                                          : _getCurrentIndex() +
                                              (velocity.dx > 0 ? 1 : -1);
                                  enterApp(index);
                                } else {
                                  // vertical
                                  if (velocity.dy < 0) {
                                    if (data
                                        is _TaskManagerDragEnterAnimationData) {
                                      exit();
                                    } else {
                                      flyBack();
                                    }
                                  } else {
                                    enterApp(_getCurrentIndex());
                                  }
                                }
                              }
                            } else {
                              // unlikely
                              exit();
                            }
                          },
                    child: const Center(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.f3): _ActionIntent(() {
          _reenter(_data = _TaskManagerEnterAnimationData(
            Rect.fromLTWH(
              -widget.constraints.maxWidth,
              0,
              widget.constraints.maxWidth,
              widget.constraints.maxHeight,
            ),
          ));
        }),
      },
      child: Actions(
        actions: _actions,
        child: TaskManagerData(
          enter: _enter,
          appData: null,
          duration: Duration.zero,
          child: Stack(
            children: [
              Positioned.fill(
                child: Scale(
                  enable: false,
                  constraints: widget.constraints,
                  child: widget.child,
                ),
              ),
              const Positioned.fill(child: Blur(enable: false)),
              const Positioned.fill(child: Center()),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 28,
                child: _apps.isEmpty
                    ? const Center()
                    : DragGesture(
                        behavior: HitTestBehavior.translucent,
                        onDragUpdate: (details) {
                          for (final app in _apps) {
                            app.sizeFactor = 0;
                          }
                          _reenter(_data = _TaskManagerDragEnterAnimationData(
                            DateTime.now(),
                            details.globalPosition,
                            details.globalPosition,
                          ));
                        },
                        onDragEnd: (details) {
                          _exit(_data = const _TaskManagerExitAnimationData(
                            Rect.zero,
                            _AppRect.invalid,
                          ));
                        },
                        child: const Center(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIntent extends Intent {
  const _ActionIntent(this.fn);
  final void Function() fn;
}

class _Action extends Action<_ActionIntent> {
  static final _i = _Action._internal();
  factory _Action() {
    return _i;
  }
  _Action._internal();

  @override
  void invoke(covariant _ActionIntent intent) => intent.fn();
}

class _AppRect {
  final int index;
  final Rect rect;
  final double other;

  const _AppRect(this.index, this.rect, this.other);
  static const invalid = _AppRect(-1, Rect.zero, 1);
}

abstract class _TaskManagerAnimationData {
  const _TaskManagerAnimationData();

  bool get isEnter => true;
  bool get isEnterApp => false;
  bool get isDragging => false;
  bool? get isFlyAnimation => null;
  bool get reenterEnable => true;
  bool get showDragBar => false;

  bool get hideFromWidget => false;
  Duration get hideFromWidgetDuration => const Duration(milliseconds: 200);

  Rect toStackListViewRect(BoxConstraints constraints, double reenter);
  _AppRect toAppRect(BoxConstraints constraints, double reenter);
}

class _TaskManagerAppFlyInAnimationData extends _TaskManagerAnimationData {
  const _TaskManagerAppFlyInAnimationData(this.currentAppRect);
  final _AppRect currentAppRect;

  @override
  bool get isEnterApp => true;

  @override
  bool get reenterEnable => false;

  @override
  bool get hideFromWidget => true;

  @override
  Duration get hideFromWidgetDuration => Duration.zero;

  @override
  bool get showDragBar => true;

  @override
  bool? get isFlyAnimation => true;

  Rect targetAppRect(BoxConstraints constraints) {
    return Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
  }

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    return Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.linearToEaseOut.transform(reenter);
    return _AppRect(
        currentAppRect.index,
        Rect.lerp(
          currentAppRect.rect,
          targetAppRect(constraints),
          t,
        )!,
        Tween<double>(begin: currentAppRect.other, end: 1).transform(t));
  }
}

abstract class _Base extends _TaskManagerAnimationData {
  const _Base(this.currentStackListViewRect, this.currentAppRect);

  final Rect currentStackListViewRect;
  final _AppRect currentAppRect;

  Rect targetStackListViewRect(BoxConstraints constraints) {
    return Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
  }

  Rect targetAppRect(BoxConstraints constraints) {
    return Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.linearToEaseOut.transform(reenter);
    return _AppRect(
        currentAppRect.index,
        Rect.lerp(
          currentAppRect.rect,
          targetAppRect(constraints),
          t,
        )!,
        Tween<double>(begin: currentAppRect.other, end: 1).transform(t));
  }

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    return Rect.lerp(
      currentStackListViewRect,
      targetStackListViewRect(constraints),
      Curves.linearToEaseOut.transform(reenter),
    )!;
  }
}

abstract class _Drag extends _Base {
  final Offset start;
  final Offset current;
  final DateTime touchStartTime;

  const _Drag(
    this.touchStartTime,
    this.start,
    this.current,
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  bool get isDragging => true;

  _Drag moveTo(Offset current);
}

class _TaskManagerDragEnterAnimationData extends _Drag {
  const _TaskManagerDragEnterAnimationData(
    final DateTime touchStartTime,
    final Offset start,
    final Offset current,
  ) : super(
          touchStartTime,
          start,
          current,
          Rect.zero,
          _AppRect.invalid,
        );

  @override
  _TaskManagerDragEnterAnimationData moveTo(Offset current) {
    return _TaskManagerDragEnterAnimationData(touchStartTime, start, current);
  }

  @override
  Rect targetStackListViewRect(BoxConstraints constraints) {
    final shift = current - start - Offset(0, constraints.maxHeight / 12);
    final bottom = constraints.maxHeight + shift.dy;
    final top = -shift.dy;
    final height = bottom - top;
    final width = constraints.maxWidth * height / constraints.maxHeight;
    final heightCenter = (bottom + top) / 2;
    return Rect.fromCenter(
      center: Offset(
        shift.dx - width / 2,
        heightCenter,
      ),
      width: width,
      height: height,
    );
  }

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    return targetStackListViewRect(constraints);
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    return _AppRect.invalid;
  }
}

class _TaskManagerDragAnimationData extends _Drag {
  const _TaskManagerDragAnimationData(
    super.touchStartTime,
    super.start,
    super.current,
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  bool get reenterEnable => false;

  @override
  _TaskManagerDragAnimationData moveTo(Offset current) {
    return _TaskManagerDragAnimationData(
      touchStartTime,
      start,
      current,
      currentStackListViewRect,
      currentAppRect,
    );
  }

  @override
  Rect targetStackListViewRect(BoxConstraints constraints) {
    final shift = current - start;
    final bottom = constraints.maxHeight + shift.dy;
    final top = -shift.dy / 2;
    final height = bottom - top;
    final width = constraints.maxWidth * height / constraints.maxHeight;
    final heightCenter = (bottom + top) / 2;
    return Rect.fromCenter(
      center: Offset(constraints.maxWidth / 2 + shift.dx, heightCenter),
      width: width,
      height: height,
    );
  }
}

class _TaskManagerDragAppAnimationData extends _Drag {
  const _TaskManagerDragAppAnimationData(
    super.touchStartTime,
    super.start,
    super.current,
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  bool get showDragBar => true;

  @override
  _TaskManagerDragAppAnimationData moveTo(Offset current) {
    return _TaskManagerDragAppAnimationData(
      touchStartTime,
      start,
      current,
      currentStackListViewRect,
      currentAppRect,
    );
  }

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    final shift = current - start;
    final bottom = constraints.maxHeight + shift.dy;
    final top = -shift.dy / 2;
    final height = bottom - top;
    final width = constraints.maxWidth * height / constraints.maxHeight;
    final heightCenter = (bottom + top) / 2;
    return Rect.fromCenter(
      center: Offset(constraints.maxWidth / 2 + shift.dx, heightCenter),
      width: width,
      height: height,
    );
  }
}

class _TaskManagerEnterAnimationData extends _Base {
  const _TaskManagerEnterAnimationData(
    super.currentStackListViewRect, [
    super.currentAppRect = _AppRect.invalid,
  ]);

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    return Rect.fromLTWH(
      constraints.maxWidth * 1 / 6,
      constraints.maxHeight * 1 / 6,
      constraints.maxWidth * 2 / 3,
      constraints.maxHeight * 2 / 3,
    );
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.linearToEaseOut.transform(reenter);
    return _AppRect(
        currentAppRect.index,
        Rect.lerp(
          currentAppRect.rect,
          targetAppRect(constraints),
          t,
        )!,
        Tween<double>(begin: currentAppRect.other, end: 2 / 3).transform(t));
  }
}

class _TaskManagerEnterAppAnimationData extends _Base {
  _TaskManagerEnterAppAnimationData(
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  bool get isEnterApp => true;

  @override
  bool get reenterEnable => false;

  @override
  bool get showDragBar => true;
}

class _Exit extends _Base {
  const _Exit(super.currentStackListViewRect, super.currentAppRect);

  @override
  bool get isEnter => false;

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    return Rect.lerp(
      targetStackListViewRect(constraints),
      currentStackListViewRect,
      Curves.easeInToLinear.transform(reenter),
    )!;
  }

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    return currentAppRect.rect;
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.easeInToLinear.transform(reenter);
    return _AppRect(
        currentAppRect.index,
        Rect.lerp(
          targetAppRect(constraints),
          currentAppRect.rect,
          t,
        )!,
        currentAppRect.other);
  }
}

class _TaskManagerExitAnimationData extends _Exit {
  const _TaskManagerExitAnimationData(
      super.currentStackListViewRect, super.currentAppRect);

  @override
  Rect targetStackListViewRect(BoxConstraints constraints) {
    return Rect.fromCenter(
      center: Offset(-constraints.maxWidth * 2, constraints.maxHeight / 2),
      width: constraints.maxWidth,
      height: constraints.maxHeight,
    );
  }
}

class _TaskManagerExitAppAnimationData extends _Exit {
  const _TaskManagerExitAppAnimationData(
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    return Rect.fromLTWH(
      constraints.maxWidth / 2,
      constraints.maxHeight / 3,
      0,
      0,
    );
  }
}

class _TaskManagerAppFlyBackAnimationData extends _Exit {
  const _TaskManagerAppFlyBackAnimationData(
      super.currentStackListViewRect, super.currentAppRect, this.targetRect);
  final Rect targetRect;

  @override
  bool get hideFromWidget => true;

  @override
  bool? get isFlyAnimation => false;

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    return targetRect;
  }
}
