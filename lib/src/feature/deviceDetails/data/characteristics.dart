class Characteristics {
  final double averageTemperature;
  final double minimalTemperature;
  final double maximalTemperature;
  final double averageHumidity;
  final int minimalHumidity;
  final int maximalHumidity;
  final DateTime day;

//<editor-fold desc="Data Methods">

  const Characteristics({
    required this.averageTemperature,
    required this.minimalTemperature,
    required this.maximalTemperature,
    required this.averageHumidity,
    required this.minimalHumidity,
    required this.maximalHumidity,
    required this.day,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Characteristics &&
          runtimeType == other.runtimeType &&
          averageTemperature == other.averageTemperature &&
          minimalTemperature == other.minimalTemperature &&
          maximalTemperature == other.maximalTemperature &&
          averageHumidity == other.averageHumidity &&
          minimalHumidity == other.minimalHumidity &&
          maximalHumidity == other.maximalHumidity &&
          day == other.day);

  @override
  int get hashCode =>
      averageTemperature.hashCode ^
      minimalTemperature.hashCode ^
      maximalTemperature.hashCode ^
      averageHumidity.hashCode ^
      minimalHumidity.hashCode ^
      maximalHumidity.hashCode ^
      day.hashCode;

  @override
  String toString() {
    return 'Characteristics{ averageTemperature: $averageTemperature, minimalTemperature: $minimalTemperature, maximalTemperature: $maximalTemperature, averageHumidity: $averageHumidity, minimalHumidity: $minimalHumidity, maximalHumidity: $maximalHumidity, day: $day,}';
  }

  Characteristics copyWith({
    double? averageTemperature,
    double? minimalTemperature,
    double? maximalTemperature,
    double? averageHumidity,
    int? minimalHumidity,
    int? maximalHumidity,
    DateTime? day,
  }) {
    return Characteristics(
      averageTemperature: averageTemperature ?? this.averageTemperature,
      minimalTemperature: minimalTemperature ?? this.minimalTemperature,
      maximalTemperature: maximalTemperature ?? this.maximalTemperature,
      averageHumidity: averageHumidity ?? this.averageHumidity,
      minimalHumidity: minimalHumidity ?? this.minimalHumidity,
      maximalHumidity: maximalHumidity ?? this.maximalHumidity,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'averageTemperature': averageTemperature,
      'minimalTemperature': minimalTemperature,
      'maximalTemperature': maximalTemperature,
      'averageHumidity': averageHumidity,
      'minimalHumidity': minimalHumidity,
      'maximalHumidity': maximalHumidity,
      'day': day,
    };
  }

  factory Characteristics.fromMap(Map<String, dynamic> map) {
    return Characteristics(
      averageTemperature: map['averageTemperature'] as double,
      minimalTemperature: map['minimalTemperature'] as double,
      maximalTemperature: map['maximalTemperature'] as double,
      averageHumidity: map['averageHumidity'] as double,
      minimalHumidity: map['minimalHumidity'] as int,
      maximalHumidity: map['maximalHumidity'] as int,
      day: map['day'] as DateTime,
    );
  }

//</editor-fold>
}
