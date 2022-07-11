class TimeManager {
  TimeManager();

  DateTime getNow() {
    return DateTime.now();
  }

  int getNowTimeStamp() {
    return getNow().millisecondsSinceEpoch;
  }

  formatToDate() {}
}
