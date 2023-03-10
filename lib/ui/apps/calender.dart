import 'package:flutter/material.dart';
import 'package:my_web/core/data/app_data.dart';

class Calender extends StatelessWidget {
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

  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.calendar_month);
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          child: _Weekday(now: now),
        ),
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w300,
          ),
          child: _Day(
            now: now,
          ),
        ),
      ],
    );
  }
}

class _Weekday extends StatelessWidget {
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

  const _Weekday({required this.now});
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
