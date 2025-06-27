import 'package:intl/intl.dart';

extension HelperDateTimeNullableExtensions on DateTime? {
  String? get toDMY {
    return this != null ? DateFormat("dd-MM-yyyy").format(this!) : null;
  }

  String? get toMMM {
    return this != null ? DateFormat("MMM").format(this!) : null;
  }

  String? get toDD {
    return this != null ? DateFormat("dd").format(this!) : null;
  }

  String? get ddMMMyyyy {
    return this != null ? DateFormat("dd MMM yyyy").format(this!) : null;
  }

  bool get isToday {
    DateTime now = DateTime.now();
    return this?.year == now.year &&
        this?.month == now.month &&
        this?.day == now.day;
  }
}

extension DateTimeExtensions on DateTime {
  int get elapsedSeconds {
    DateTime now = DateTime.now();
    Duration difference = now.difference(this);
    return difference.inSeconds;
  }

  DateTime get firstDayOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get lastDayOfMonth {
    return DateTime(year, month + 1, 0);
  }

  List<DateTime> get daysInMonth {
    return List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(year, month, index + 1),
    );
  }

  String get greeting {
    final hour = this.hour;
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 18) {
      return 'Good afternoon,';
    } else if (hour < 22) {
      return 'Good evening,';
    } else {
      return 'Good night,';
    }
  }

  DateTime get startOfWeek {
    final difference = weekday % 7;
    return subtract(Duration(days: difference));
  }

  DateTime get endOfWeek {
    final difference = 6 - (weekday % 7);
    return add(Duration(days: difference));
  }
}
