import 'package:flutter/material.dart';

class DelayShow extends StatefulWidget {
  const DelayShow({
    Key key,
    @required this.show,
    @required this.child,
    @required this.delay,
    this.placeHolder = const SizedBox(),
  }) : super(key: key);
  final bool show;
  final Widget child;
  final Widget placeHolder;
  final Duration delay;

  @override
  _DelayShowState createState() => _DelayShowState();
}

class _DelayShowState extends State<DelayShow> {
  Widget _child;

  @override
  void initState() {
    super.initState();
    _child = widget.placeHolder;
    _delayShow();
  }

  @override
  void didUpdateWidget(covariant DelayShow oldWidget) {
    if (widget.show && widget.show) _delayShow();
    super.didUpdateWidget(oldWidget);
  }

  void _delayShow() {
    Future.delayed(widget.delay, () async {
      if (mounted && widget.show)
        setState(() {
          _child = widget.child;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
