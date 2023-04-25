import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/box_constraints_extension.dart';
import 'package:my_web/ui/widgets/image_filtered_scale.dart';
import 'package:my_web/ui/widgets/simple_shortcuts.dart';

import 'task_manager_view/blur.dart';
import 'task_manager_view/stack_list_view.dart';
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
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _scaleController;
  late AnimationController _reenterController;
  late BoxConstraints _layoutConstraints;
  final List<StackListViewData<AppData>> _apps = [];
  final ValueNotifier<DragEndDetails> _returnHome =
      ValueNotifier(DragEndDetails());

  _TaskManagerData? _data;
  AppData? _focusApp;
  bool _isFocusAppDirty = false;

  Rect _getRect(RenderBox box) {
    final size = box.size;
    final offset = box.localToGlobal(
      Offset.zero,
      ancestor: context.findRenderObject(),
    );
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  void _updateSnapshot() {
    if (_isFocusAppDirty) {
      _focusApp?.updateSnapshot();
      _isFocusAppDirty = false;
    }
  }

  void _enter(AppData data) {
    _focusApp = data;
    final index = _apps.indexWhere((element) {
      return element.data == data;
    });
    if (index != -1) _apps.removeAt(index);
    _apps.insert(0, StackListViewData<AppData>(0, ValueKey(data), data));

    final context = data.iconKey.currentContext;
    if (context == null) {
      _reenter(
        _data = _TaskManagerEnterAppAnimationData(
          widget.constraints.toRect(left: widget.constraints.maxWidth),
          _AppRect(
            0,
            widget.constraints.toRect(left: widget.constraints.maxWidth),
            widget.constraints.toRect(),
          ),
        ),
      );
    } else {
      final start = context.findRenderObject() as RenderBox;
      final rect = _getRect(start);
      _reenter(_data = _TaskManagerAppFlyInAnimationData(
        _AppRect(0, rect, widget.constraints.toRect()),
      ));
    }
  }

  void _reenter(_TaskManagerAnimationData data) async {
    assert(data.stats != TaskManagerStats.exit);
    _updateSnapshot();
    switch (data.stats) {
      case TaskManagerStats.enterApp:
        _isFocusAppDirty = true;
        break;
      default:
    }
    _scaleController.animateTo(1);
    _reenterController.value = 0;
    await _reenterController.animateTo(1);
    if (_reenterController.isCompleted &&
        data.stats == TaskManagerStats.enterApp) {
      final index = _getCurrentIndex();
      if (index > -1 && index < _apps.length) {
        final app = _apps[index].data;
        if (_focusApp != app) {
          setState(() {
            _focusApp = app;
          });
        }
      }
    }
  }

  void _exit(_TaskManagerAnimationData data) async {
    assert(data.stats == TaskManagerStats.exit);
    _updateSnapshot();
    _scaleController.animateBack(0, curve: Curves.ease);
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
    if (_apps.length < 2) return;
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
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
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
    _scaleController.dispose();
    _reenterController.dispose();
    _scrollController.dispose();
    _returnHome.dispose();
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
      final flyAnimation = data.flyAnimation;
      final appData = (flyAnimation != null &&
              appRect.index > -1 &&
              appRect.index < _apps.length)
          ? _apps[appRect.index].data
          : null;
      final cardPadding = EdgeInsets.symmetric(
        horizontal:
            (_layoutConstraints.maxWidth - widget.constraints.maxWidth) / 2,
      );

      void directlyEnterTaskManager() {
        _reenter(_data = _TaskManagerEnterAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      void enterTaskManager(TaskManagerStats stats) {
        final index = _getCurrentIndex();
        if (index == 0 && stats == TaskManagerStats.enterApp) {
          _scrollToIndex((1).clamp(0, _apps.length - 1));
        }
        directlyEnterTaskManager();
      }

      void enterApp(int index) {
        final i = index.clamp(0, _apps.length - 1);
        _focusApp = _apps[i].data;
        _scrollToIndex(i);
        _reenter(_data = _TaskManagerEnterAppAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      void flyBack() {
        final index = _getCurrentIndex();
        _scrollToIndex(index);
        final nextAppRect = _AppRect(
          index,
          appRect.index == index ? appRect.rect : appRect.other,
          appRect.other,
        );

        final rect = () {
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
        }();
        if (rect != null) {
          _exit(_data = _TaskManagerAppFlyBackAnimationData(
            stackListViewRect,
            nextAppRect,
            rect,
          ));
        } else {
          _exit(_data = _TaskManagerAppExitAnimationData(
            stackListViewRect,
            nextAppRect,
          ));
        }
      }

      void forceExit() {
        _exit(_data = _TaskManagerExitAnimationData(
          stackListViewRect,
          appRect,
        ));
      }

      final bool isEnter;
      final bool reenterEnable;
      final bool isEnterApp;
      final void Function() exit;
      final Map<ShortcutActivator, void Function()> shortcuts;

      switch (data.stats) {
        case TaskManagerStats.enter:
          isEnter = true;
          reenterEnable = true;
          isEnterApp = false;
          exit = forceExit;
          shortcuts = {
            LogicalKeySet(LogicalKeyboardKey.escape): exit,
            LogicalKeySet(LogicalKeyboardKey.f3): exit,
            LogicalKeySet(LogicalKeyboardKey.space): () =>
                enterApp(_getCurrentIndex()),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft): () =>
                _scrollToIndex(_getCurrentIndex() + 1),
            LogicalKeySet(LogicalKeyboardKey.arrowRight): () =>
                _scrollToIndex(_getCurrentIndex() - 1),
          };
          break;
        case TaskManagerStats.enterApp:
          isEnter = true;
          reenterEnable = false;
          isEnterApp = true;
          exit = forceExit;
          shortcuts = {
            LogicalKeySet(LogicalKeyboardKey.escape): flyBack,
            LogicalKeySet(LogicalKeyboardKey.f3): directlyEnterTaskManager,
          };
          break;
        case TaskManagerStats.drag:
          isEnter = true;
          reenterEnable = false;
          isEnterApp = false;
          exit = () {};
          shortcuts = const {};
          break;
        case TaskManagerStats.exit:
          isEnter = false;
          reenterEnable = true;
          isEnterApp = false;
          exit = () {};
          shortcuts = {
            LogicalKeySet(LogicalKeyboardKey.f3): directlyEnterTaskManager,
            LogicalKeySet(LogicalKeyboardKey.space): () =>
                enterApp(_getCurrentIndex()),
          };
          break;
      }

      return SimpleShortcuts(
        shortcuts: shortcuts,
        child: TaskManagerData(
          returnHome: _returnHome,
          enter: _enter,
          appData: appData,
          hideWidgetDuration: flyAnimation?.hideWidgetDuration ??
              const Duration(milliseconds: 200),
          child: Stack(
            children: [
              Positioned.fill(
                child: ImageFilteredScaleTransition(
                  scale: Tween(begin: 1.0, end: 0.9).animate(_scaleController),
                  constraints: widget.constraints,
                  child: widget.child,
                ),
              ),
              Positioned.fill(child: Blur(enable: isEnter)),
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
                        itemBuilder:
                            (context, delta, index, sizeFactor, appData) {
                          final thisData = _apps[index];
                          final isPrimary = index == appRect.index;
                          return Padding(
                            padding: cardPadding,
                            child: Stack(
                              children: [
                                Positioned.fromRect(
                                  rect:
                                      isPrimary ? appRect.rect : appRect.other,
                                  child: TaskManagerAppCard(
                                    flyStats: isPrimary
                                        ? flyAnimation?.flyStats
                                        : null,
                                    appData: appData,
                                    constraints: widget.constraints,
                                    delta: delta,
                                    showDragBar: data.showDragBar,
                                    sizeFactor: sizeFactor,
                                    isEnterTaskManager: isEnterTaskManager,
                                    isFocus: appData == _focusApp,
                                    isEnterApp: isEnterApp,
                                    reenterEnable: reenterEnable,
                                    reenterApp: () {
                                      return enterApp(index);
                                    },
                                    updateSizeFactor: (value) {
                                      return setState(() {
                                        thisData.sizeFactor = value;
                                      });
                                    },
                                    removeApp: () {
                                      return setState(() {
                                        _apps.remove(thisData);
                                      });
                                    },
                                  ),
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
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragUpdate: !isEnter
                      ? (details) {}
                      : (details) {
                          bool isLongDrag(DateTime touchStartTime) {
                            final now = DateTime.now();
                            final delta = now.difference(touchStartTime);
                            return delta > const Duration(milliseconds: 150);
                          }

                          bool toTaskManager(
                              Offset shift, DateTime? touchStartTime) {
                            if (shift.dx.abs() > shift.dy.abs() * 1.5) {
                              return true;
                            } else if (shift.distance <
                                    widget.constraints.maxHeight / 3 &&
                                (touchStartTime == null ||
                                    isLongDrag(touchStartTime))) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          if (data is _TaskManagerDragAnimationData) {
                            final shift = details.globalPosition - data.start;
                            if (toTaskManager(shift, null)) {
                              setState(() {
                                _data = data.moveTo(details.globalPosition);
                              });
                            } else {
                              final index = _getCurrentIndex();
                              _reenter(_data = _TaskManagerDragAppAnimationData(
                                data.touchStartTime,
                                data.start,
                                details.globalPosition,
                                stackListViewRect,
                                _AppRect(
                                  index,
                                  appRect.index == index
                                      ? appRect.rect
                                      : appRect.other,
                                  appRect.other,
                                ),
                                data.showDragBar,
                                data.lastStats,
                              ));
                            }
                          } else if (data is _TaskManagerDragAppAnimationData) {
                            final shift = details.globalPosition - data.start;
                            final willDragStopMoving =
                                details.delta.distance < 3;
                            if (toTaskManager(
                                shift,
                                willDragStopMoving
                                    ? null
                                    : data.touchStartTime)) {
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
                                      : appRect.other,
                                  appRect.other,
                                ),
                                data.showDragBar,
                                data.lastStats,
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
                                current.dy +
                                    widget.constraints.maxHeight -
                                    appRect.other.height -
                                    appRect.other.top);
                            final shift = current - start;
                            final touchStartTime = DateTime.now();
                            if (toTaskManager(
                                shift, isEnterApp ? touchStartTime : null)) {
                              _reenter(_data = _TaskManagerDragAnimationData(
                                touchStartTime,
                                start,
                                details.globalPosition,
                                stackListViewRect,
                                appRect,
                                data.showDragBar,
                                data.stats,
                              ));
                            } else {
                              final index = _getCurrentIndex();
                              _scrollToIndex(index);
                              _reenter(_data = _TaskManagerDragAppAnimationData(
                                touchStartTime,
                                start,
                                details.globalPosition,
                                stackListViewRect,
                                _AppRect(
                                    index,
                                    appRect.index == index
                                        ? appRect.rect
                                        : appRect.other,
                                    appRect.other),
                                data.showDragBar,
                                data.stats,
                              ));
                            }
                          }
                        },
                  onVerticalDragEnd: !isEnter
                      ? (details) {}
                      : (details) {
                          if (data is _Drag) {
                            final velocity = details.velocity.pixelsPerSecond;
                            if (velocity.distance < 200) {
                              // drag speed slow
                              final delta = data.current - data.start;
                              if (delta.dx.abs() > delta.dy.abs()) {
                                // horizontal
                                final index =
                                    data is _TaskManagerDragEnterAnimationData
                                        ? _getCurrentIndex()
                                        : _getCurrentIndex() +
                                            (delta.dx > 0 ? 1 : -1);
                                enterApp(index);
                              } else {
                                // vertical
                                if (data
                                    is _TaskManagerDragEnterAnimationData) {
                                  enterTaskManager(data.lastStats);
                                } else if (-delta.dy <
                                    widget.constraints.maxHeight / 9) {
                                  enterApp(_getCurrentIndex());
                                } else {
                                  enterTaskManager(data.lastStats);
                                }
                              }
                            } else {
                              // drag speed fast
                              if (velocity.dx.abs() > velocity.dy.abs() * 1.5) {
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
                                    forceExit();
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
                            if (isEnterApp) {
                              flyBack();
                            } else {
                              forceExit();
                            }
                          }
                        },
                  child: const Center(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SimpleShortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.f3): () {
          final current = widget.constraints.toRect();
          _reenter(_data = _TaskManagerEnterAnimationData(
              widget.constraints.toRect(left: -widget.constraints.maxWidth),
              _AppRect(-1, current, current)));
        },
      },
      child: TaskManagerData(
        returnHome: _returnHome,
        enter: _enter,
        hideWidgetDuration: Duration.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFilteredScaleTransition(
                scale: Tween(begin: 1.0, end: 0.9).animate(_scaleController),
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
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) {
                  _scaleController.value -=
                      details.delta.dy / widget.constraints.maxHeight;
                  if (data is _TaskManagerGestureData) {
                    final d = details.globalPosition - data.start;
                    if ((details.delta.dy < 0 &&
                            details.delta.dy.abs() <
                                (1 + _scaleController.value) / 2) ||
                        (d.dx.abs() > d.dy.abs() && d.dx > 0)) {
                      _reenter(_data = _TaskManagerDragEnterAnimationData(
                        DateTime.now(),
                        Offset(details.globalPosition.dx,
                            widget.constraints.maxHeight),
                        details.globalPosition,
                      ));
                    } else {
                      setState(() {
                        _data = _TaskManagerGestureData(
                          data.start,
                          details.globalPosition,
                        );
                      });
                    }
                  } else {
                    setState(() {
                      _data = _TaskManagerGestureData(
                        details.globalPosition,
                        details.globalPosition,
                      );
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  _scaleController.animateBack(0, curve: Curves.ease);
                  _data = null;
                  _reenterController.value = 0;
                  _returnHome.value = details;
                },
                child: const Center(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppRect {
  const _AppRect(this.index, this.rect, this.other);
  final int index;
  final Rect rect;
  final Rect other;
  static const invalid = _AppRect(-1, Rect.zero, Rect.zero);
}

abstract class _TaskManagerData {
  const _TaskManagerData();
}

class _TaskManagerGestureData extends _TaskManagerData {
  const _TaskManagerGestureData(this.start, this.current);
  final Offset start;
  final Offset current;
}

abstract class _TaskManagerAnimationData extends _TaskManagerData {
  const _TaskManagerAnimationData();

  TaskManagerStats get stats;
  FlyAnimation? get flyAnimation => null;
  bool get showDragBar => false;

  Rect toStackListViewRect(BoxConstraints constraints, double reenter);
  _AppRect toAppRect(BoxConstraints constraints, double reenter);
}

class _TaskManagerAppFlyInAnimationData extends _TaskManagerAnimationData {
  const _TaskManagerAppFlyInAnimationData(this.currentAppRect);
  final _AppRect currentAppRect;

  @override
  TaskManagerStats get stats => TaskManagerStats.enterApp;

  @override
  FlyAnimation get flyAnimation => const FlyAnimation(
        hideWidgetDuration: Duration.zero,
        flyStats: FlyStats.enter,
      );

  @override
  bool get showDragBar => true;

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    return constraints.toRect();
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.linearToEaseOut.transform(reenter);
    final target = constraints.toRect();
    return _AppRect(
      currentAppRect.index,
      Rect.lerp(currentAppRect.rect, target, t)!,
      target,
    );
  }
}

abstract class _Base extends _TaskManagerAnimationData {
  const _Base(this.currentStackListViewRect, this.currentAppRect);

  final Rect currentStackListViewRect;
  final _AppRect currentAppRect;

  Rect targetAppRect(BoxConstraints constraints) {
    return constraints.toRect();
  }

  Rect targetAppOtherRect(BoxConstraints constraints) {
    return constraints.toRect();
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final t = Curves.linearToEaseOut.transform(reenter);
    return _AppRect(
      currentAppRect.index,
      Rect.lerp(currentAppRect.rect, targetAppRect(constraints), t)!,
      Rect.lerp(currentAppRect.other, targetAppOtherRect(constraints), t)!,
    );
  }

  Rect targetStackListViewRect(BoxConstraints constraints) {
    return constraints.toRect();
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
  const _Drag(
    this.touchStartTime,
    this.start,
    this.current,
    super.currentStackListViewRect,
    super.currentAppRect,
    this.showDragBar,
    this.lastStats,
  );
  final Offset start;
  final Offset current;
  final DateTime touchStartTime;
  final TaskManagerStats lastStats;

  @override
  final bool showDragBar;

  @override
  TaskManagerStats get stats => TaskManagerStats.drag;

  _Drag moveTo(Offset current);
}

class _TaskManagerDragEnterAnimationData extends _Drag {
  const _TaskManagerDragEnterAnimationData(
    final DateTime touchStartTime,
    final Offset start,
    final Offset current,
  ) : super(touchStartTime, start, current, Rect.zero, _AppRect.invalid, false,
            TaskManagerStats.exit);

  @override
  _TaskManagerDragEnterAnimationData moveTo(Offset current) {
    return _TaskManagerDragEnterAnimationData(touchStartTime, start, current);
  }

  @override
  Rect toStackListViewRect(BoxConstraints constraints, double reenter) {
    final shift = current - start - Offset(0, constraints.maxHeight / 12);
    final bottom = constraints.maxHeight + shift.dy;
    final top = -shift.dy;
    final height = bottom - top;
    final width = constraints.maxWidth * height / constraints.maxHeight;
    final heightCenter = (bottom + top) / 2;
    return Rect.fromCenter(
      center: Offset(shift.dx - width / 2, heightCenter),
      width: width,
      height: height,
    );
  }

  @override
  _AppRect toAppRect(BoxConstraints constraints, double reenter) {
    final target = constraints.toRect();
    return _AppRect(-1, target, target);
  }
}

class _TaskManagerDragAnimationData extends _Drag {
  const _TaskManagerDragAnimationData(
    super.touchStartTime,
    super.start,
    super.current,
    super.currentStackListViewRect,
    super.currentAppRect,
    super.showDragBar,
    super.lastStats,
  );

  @override
  _TaskManagerDragAnimationData moveTo(Offset current) {
    return _TaskManagerDragAnimationData(
      touchStartTime,
      start,
      current,
      currentStackListViewRect,
      currentAppRect,
      showDragBar,
      lastStats,
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
    super.showDragBar,
    super.lastStats,
  );

  @override
  _TaskManagerDragAppAnimationData moveTo(Offset current) {
    return _TaskManagerDragAppAnimationData(
      touchStartTime,
      start,
      current,
      currentStackListViewRect,
      currentAppRect,
      showDragBar,
      lastStats,
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
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  TaskManagerStats get stats => TaskManagerStats.enter;

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
  Rect targetAppOtherRect(BoxConstraints constraints) {
    return Rect.fromLTWH(
      constraints.maxWidth * 1 / 6,
      constraints.maxHeight * 1 / 6,
      constraints.maxWidth * 2 / 3,
      constraints.maxHeight * 2 / 3,
    );
  }
}

class _TaskManagerEnterAppAnimationData extends _Base {
  _TaskManagerEnterAppAnimationData(
    super.currentStackListViewRect,
    super.currentAppRect,
  );

  @override
  TaskManagerStats get stats => TaskManagerStats.enterApp;

  @override
  bool get showDragBar => true;
}

class _Exit extends _Base {
  const _Exit(super.currentStackListViewRect, super.currentAppRect);

  @override
  TaskManagerStats get stats => TaskManagerStats.exit;

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
      Rect.lerp(targetAppRect(constraints), currentAppRect.rect, t)!,
      currentAppRect.other,
    );
  }
}

class _TaskManagerExitAnimationData extends _Exit {
  const _TaskManagerExitAnimationData(
      super.currentStackListViewRect, super.currentAppRect);

  @override
  Rect targetStackListViewRect(BoxConstraints constraints) {
    return constraints.toRect(left: -constraints.maxWidth * 2);
  }
}

class _TaskManagerAppExitAnimationData extends _Exit {
  const _TaskManagerAppExitAnimationData(
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
  FlyAnimation get flyAnimation => const FlyAnimation(
        hideWidgetDuration: Duration(milliseconds: 200),
        flyStats: FlyStats.exit,
      );

  @override
  Rect targetAppRect(BoxConstraints constraints) {
    return targetRect;
  }
}
