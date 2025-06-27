import 'package:flutter/material.dart';

extension HelperTimeOfDayExtensions on TimeOfDay {
  int toMinutes() {
    int hour = hourOfPeriod;
    if (period == DayPeriod.pm && hour != 12) {
      hour += 12;
    }
    if (period == DayPeriod.am && hour == 12) {
      hour = 0;
    }
    return hour * 60 + minute;
  }

  bool get hasPassed {
    final now = DateTime.now();

    return now.hour > hour || (now.hour == hour && now.minute >= minute);
  }
}
