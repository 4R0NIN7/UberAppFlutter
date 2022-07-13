class CharacteristicsEntity {
  final double averageTemperature;
  final double minimalTemperature;
  final double maximalTemperature;
  final double averageHumidity;
  final int minimalHumidity;
  final int maximalHumidity;
  final DateTime dateTimeValue;

//<editor-fold desc="Data Methods">

  const CharacteristicsEntity({
    required this.averageTemperature,
    required this.minimalTemperature,
    required this.maximalTemperature,
    required this.averageHumidity,
    required this.minimalHumidity,
    required this.maximalHumidity,
    required this.dateTimeValue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacteristicsEntity &&
          runtimeType == other.runtimeType &&
          averageTemperature == other.averageTemperature &&
          minimalTemperature == other.minimalTemperature &&
          maximalTemperature == other.maximalTemperature &&
          averageHumidity == other.averageHumidity &&
          minimalHumidity == other.minimalHumidity &&
          maximalHumidity == other.maximalHumidity &&
          dateTimeValue == other.dateTimeValue);

  @override
  int get hashCode =>
      averageTemperature.hashCode ^
      minimalTemperature.hashCode ^
      maximalTemperature.hashCode ^
      averageHumidity.hashCode ^
      minimalHumidity.hashCode ^
      maximalHumidity.hashCode ^
      dateTimeValue.hashCode;

  @override
  String toString() {
    return 'CharacteristicsEntity{ averageTemperature: '
        '$averageTemperature, minimalTemperature: '
        '$minimalTemperature, maximalTemperature: '
        '$maximalTemperature, averageHumidity: '
        '$averageHumidity, minimalHumidity: '
        '$minimalHumidity, maximalHumidity: '
        '$maximalHumidity, dateTimeValue: '
        '$dateTimeValue,}';
  }

  CharacteristicsEntity copyWith({
    double? averageTemperature,
    double? minimalTemperature,
    double? maximalTemperature,
    double? averageHumidity,
    int? minimalHumidity,
    int? maximalHumidity,
    DateTime? dateTimeValue,
  }) {
    return CharacteristicsEntity(
      averageTemperature: averageTemperature ?? this.averageTemperature,
      minimalTemperature: minimalTemperature ?? this.minimalTemperature,
      maximalTemperature: maximalTemperature ?? this.maximalTemperature,
      averageHumidity: averageHumidity ?? this.averageHumidity,
      minimalHumidity: minimalHumidity ?? this.minimalHumidity,
      maximalHumidity: maximalHumidity ?? this.maximalHumidity,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
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
      'dateTimeValue': dateTimeValue,
    };
  }

  factory CharacteristicsEntity.fromMap(Map<String, dynamic> map) {
    return CharacteristicsEntity(
      averageTemperature: map['averageTemperature'] as double,
      minimalTemperature: map['minimalTemperature'] as double,
      maximalTemperature: map['maximalTemperature'] as double,
      averageHumidity: map['averageHumidity'] as double,
      minimalHumidity: map['minimalHumidity'] as int,
      maximalHumidity: map['maximalHumidity'] as int,
      dateTimeValue: map['dateTimeValue'] as DateTime,
    );
  }

//</editor-fold>
}
