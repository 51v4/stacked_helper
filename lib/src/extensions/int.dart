extension HelperIntExtensions on int {
  String get toTimeString {
    String time = Duration(seconds: this).toString();
    return time.substring(time.indexOf(':') + 1, time.lastIndexOf('.'));
  }
}
