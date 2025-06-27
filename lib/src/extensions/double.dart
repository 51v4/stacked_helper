import 'package:intl/intl.dart';

extension HelperDoubleExtensions on double? {
  String get formattedString {
    if (this == null) return '';

    var formatter = NumberFormat("#,##0.00");

    var str = formatter.format(this!);
    var strList = str.split('.');
    if (strList.length == 2) {
      var fraction = strList.last;
      if (fraction == '00') {
        return strList.first;
      }
      if (fraction[fraction.length - 1] == '0') {
        return str.substring(0, str.length - 1);
      }
      return str;
    }
    return "";
  }

  String? get formatedCurrency {
    if (this == null) return null;

    bool isWholeNumber = this == this!.toInt();

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: isWholeNumber ? 0 : 2,
    );
    return formatter.format(this);
  }

  String? get removeTrailingZeros {
    if (this == null) return null;

    bool isWholeNumber = this == this!.toInt();

    if (isWholeNumber) {
      return this!.toInt().toString();
    }

    return this!.toStringAsFixed(2);
  }
}
