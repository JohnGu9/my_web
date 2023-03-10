import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DragGesture extends StatefulWidget {
  const DragGesture({
    super.key,
    required this.child,
    this.behavior = HitTestBehavior.deferToChild,
    this.onDragDown,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
  });
  final Widget child;
  final HitTestBehavior behavior;

  /// A pointer has contacted the screen with a primary button and might begin
  /// to move.
  ///
  /// The position of the pointer is provided in the callback's `details`
  /// argument, which is a [DragDownDetails] object.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DragDownDetails], which is passed as an argument to this callback.
  final GestureDragDownCallback? onDragDown;

  /// A pointer has contacted the screen with a primary button and has begun to
  /// move.
  ///
  /// The position of the pointer is provided in the callback's `details`
  /// argument, which is a [DragStartDetails] object. The [dragStartBehavior]
  /// determines this position.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DragStartDetails], which is passed as an argument to this callback.
  final GestureDragStartCallback? onDragStart;

  /// A pointer that is in contact with the screen with a primary button and
  /// moving has moved again.
  ///
  /// The distance traveled by the pointer since the last update is provided in
  /// the callback's `details` argument, which is a [DragUpdateDetails] object.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DragUpdateDetails], which is passed as an argument to this callback.
  final GestureDragUpdateCallback? onDragUpdate;

  /// A pointer that was previously in contact with the screen with a primary
  /// button and moving is no longer in contact with the screen and was moving
  /// at a specific velocity when it stopped contacting the screen.
  ///
  /// The velocity is provided in the callback's `details` argument, which is a
  /// [DragEndDetails] object.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [DragEndDetails], which is passed as an argument to this callback.
  final GestureDragEndCallback? onDragEnd;

  /// The pointer that previously triggered [onDragDown] did not complete.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final GestureDragCancelCallback? onDragCancel;

  /// A pointer has contacted the screen at a particular location with a primary
  /// button, which might be the start of a tap.
  ///
  /// This triggers after the down event, once a short timeout ([deadline]) has
  /// elapsed, or once the gestures has won the arena, whichever comes first.
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called next.
  /// Otherwise, [onTapUp] is called next.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapDown], a similar callback but for a secondary button.
  ///  * [onTertiaryTapDown], a similar callback but for a tertiary button.
  ///  * [TapDownDetails], which is passed as an argument to this callback.
  ///  * [GestureDetector.onTapDown], which exposes this callback.
  final GestureTapDownCallback? onTapDown;

  /// A pointer has stopped contacting the screen at a particular location,
  /// which is recognized as a tap of a primary button.
  ///
  /// This triggers on the up event, if the recognizer wins the arena with it
  /// or has previously won, immediately followed by [onTap].
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapUp], a similar callback but for a secondary button.
  ///  * [onTertiaryTapUp], a similar callback but for a tertiary button.
  ///  * [TapUpDetails], which is passed as an argument to this callback.
  ///  * [GestureDetector.onTapUp], which exposes this callback.
  final GestureTapUpCallback? onTapUp;

  /// A pointer has stopped contacting the screen, which is recognized as a tap
  /// of a primary button.
  ///
  /// This triggers on the up event, if the recognizer wins the arena with it
  /// or has previously won, immediately following [onTapUp].
  ///
  /// If this recognizer doesn't win the arena, [onTapCancel] is called instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTap], a similar callback but for a secondary button.
  ///  * [onTapUp], which has the same timing but with details.
  ///  * [GestureDetector.onTap], which exposes this callback.
  final GestureTapCallback? onTap;

  /// A pointer that previously triggered [onTapDown] will not end up causing
  /// a tap.
  ///
  /// This triggers once the gesture loses the arena if [onTapDown] has
  /// previously been triggered.
  ///
  /// If this recognizer wins the arena, [onTapUp] and [onTap] are called
  /// instead.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  ///  * [onSecondaryTapCancel], a similar callback but for a secondary button.
  ///  * [onTertiaryTapCancel], a similar callback but for a tertiary button.
  ///  * [GestureDetector.onTapCancel], which exposes this callback.
  final GestureTapCancelCallback? onTapCancel;

  @override
  State<DragGesture> createState() => _DragGestureState();
}

class _DragGestureState extends State<DragGesture> {
  late VerticalDragGestureRecognizer _recognizer;
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this)
      ..onTap = widget.onTap
      ..onTapCancel = widget.onDragCancel
      ..onTapDown = widget.onTapDown
      ..onTapUp = widget.onTapUp;

    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onCancel = widget.onDragCancel
      ..onDown = widget.onDragDown
      ..onEnd = widget.onDragEnd
      ..onStart = widget.onDragStart
      ..onUpdate = widget.onDragUpdate;
  }

  @override
  void didUpdateWidget(covariant DragGesture oldWidget) {
    _recognizer
      ..onCancel = widget.onDragCancel
      ..onDown = widget.onDragDown
      ..onEnd = widget.onDragEnd
      ..onStart = widget.onDragStart
      ..onUpdate = widget.onDragUpdate;

    _tapGestureRecognizer
      ..onTap = widget.onTap
      ..onTapCancel = widget.onDragCancel
      ..onTapDown = widget.onTapDown
      ..onTapUp = widget.onTapUp;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: widget.behavior,
      onPointerDown: (event) {
        _recognizer.addPointer(event);
        _tapGestureRecognizer.addPointer(event);
      },
      child: widget.child,
    );
  }
}
