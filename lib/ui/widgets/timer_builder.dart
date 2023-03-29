import 'dart:async';

import 'package:flutter/material.dart';

class TimerBuilder extends StatefulWidget {
  const TimerBuilder({
    super.key,
    required this.builder,
    required this.delay,
    required this.periodic,
  });
  final Duration Function() delay;
  final Duration periodic;
  final Widget Function(DateTime dateTime) builder;

  @override
  State<TimerBuilder> createState() => _TimerBuilderState();
}

class _TimerBuilderState extends State<TimerBuilder> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay(), () {
      setState(() {
        _now = DateTime.now();
      });
      _timer = Timer.periodic(widget.periodic, (timer) {
        setState(() {
          _now = DateTime.now();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_now);
  }
}
