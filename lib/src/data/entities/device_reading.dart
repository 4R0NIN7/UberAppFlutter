class DeviceReading {
  final int humidity;
  final double temperature;
  final DateTime readDateTime;
  final String deviceId;
  final bool isSynchronized;

//<editor-fold desc="Data Methods">

  const DeviceReading({
    required this.humidity,
    required this.temperature,
    required this.readDateTime,
    required this.deviceId,
    required this.isSynchronized,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceReading &&
          runtimeType == other.runtimeType &&
          humidity == other.humidity &&
          temperature == other.temperature &&
          readDateTime == other.readDateTime &&
          deviceId == other.deviceId &&
          isSynchronized == other.isSynchronized);

  @override
  int get hashCode =>
      humidity.hashCode ^
      temperature.hashCode ^
      readDateTime.hashCode ^
      deviceId.hashCode ^
      isSynchronized.hashCode;

  @override
  String toString() {
    return 'DeviceReading{ humidity: $humidity, temperature: $temperature, readDateTime: $readDateTime, deviceId: $deviceId, isSynchronized: $isSynchronized,}';
  }

  DeviceReading copyWith({
    int? humidity,
    double? temperature,
    DateTime? readDateTime,
    String? deviceId,
    bool? isSynchronized,
  }) {
    return DeviceReading(
      humidity: humidity ?? this.humidity,
      temperature: temperature ?? this.temperature,
      readDateTime: readDateTime ?? this.readDateTime,
      deviceId: deviceId ?? this.deviceId,
      isSynchronized: isSynchronized ?? this.isSynchronized,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'humidity': humidity,
      'temperature': temperature,
      'readDateTime': readDateTime,
      'deviceId': deviceId,
      'isSynchronized': isSynchronized,
    };
  }

  factory DeviceReading.fromMap(Map<String, dynamic> map) {
    return DeviceReading(
      humidity: map['humidity'] as int,
      temperature: map['temperature'] as double,
      readDateTime: map['readDateTime'] as DateTime,
      deviceId: map['deviceId'] as String,
      isSynchronized: map['isSynchronized'] as bool,
    );
  }

//</editor-fold>
}
