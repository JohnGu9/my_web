import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';
import 'package:my_web/ui/widgets/timer_builder.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});
  static final appData = AppData(
    app: const Calender(),
    icon: const _Icon(),
    iconBackground: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
    ),
    name: 'Calender',
  );

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.calendar_month);
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  static Duration beforeNextDay() {
    final now = DateTime.now();
    final nextDay =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return nextDay.difference(now);
  }

  static Widget builder(DateTime now) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
          child: _Weekday(now: now),
        ),
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w300,
          ),
          child: _Day(now: now),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const TimerBuilder(
      delay: beforeNextDay,
      periodic: Duration(days: 1),
      builder: builder,
    );
  }
}

class _Weekday extends StatelessWidget {
  const _Weekday({required this.now});
  static String toWeekdayString(int i) {
    switch (i) {
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      default:
        return "SUN";
    }
  }

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Text(toWeekdayString(now.weekday));
  }
}

class _Day extends StatelessWidget {
  const _Day({required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Text("${now.day}");
  }
}
