import 'dart:typed_data';

import 'package:intl/intl.dart';

Uint8List yearToByteList(int value) =>
    Uint8List(2)..buffer.asInt16List()[0] = value;

int fromBytesToIntYear(int b0, int b1) {
  final uIntList = Uint8List(2)
    ..[1] = b1
    ..[0] = b0;
  var buffer = uIntList.buffer;
  var bData = ByteData.view(buffer);
  return bData.getInt16(0);
}

extension DateCompare on DateTime {
  bool isSameDate(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  Uint8List dateToBytes() {
    final yearToByte = yearToByteList(year);
    return Uint8List(4)
      ..[3] = yearToByte[1]
      ..[2] = yearToByte[0]
      ..[1] = month
      ..[0] = day;
  }
}

extension DateTimeConversion on DateTime {
  String toDateString() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(this);
    return formatted;
  }
}
