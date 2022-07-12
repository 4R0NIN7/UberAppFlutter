// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ReadingEntityData extends DataClass
    implements Insertable<ReadingEntityData> {
  final int id;
  final double temperature;
  final int humidity;
  final String deviceId;
  final DateTime readDateTime;
  final bool isSynchronized;
  ReadingEntityData(
      {required this.id,
      required this.temperature,
      required this.humidity,
      required this.deviceId,
      required this.readDateTime,
      required this.isSynchronized});
  factory ReadingEntityData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ReadingEntityData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      temperature: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}temperature'])!,
      humidity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}humidity'])!,
      deviceId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}device_id'])!,
      readDateTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_time_value'])!,
      isSynchronized: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_synchronized'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['temperature'] = Variable<double>(temperature);
    map['humidity'] = Variable<int>(humidity);
    map['device_id'] = Variable<String>(deviceId);
    map['date_time_value'] = Variable<DateTime>(readDateTime);
    map['is_synchronized'] = Variable<bool>(isSynchronized);
    return map;
  }

  ReadingEntityCompanion toCompanion(bool nullToAbsent) {
    return ReadingEntityCompanion(
      id: Value(id),
      temperature: Value(temperature),
      humidity: Value(humidity),
      deviceId: Value(deviceId),
      dateTimeValue: Value(readDateTime),
      isSynchronized: Value(isSynchronized),
    );
  }

  factory ReadingEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingEntityData(
      id: serializer.fromJson<int>(json['id']),
      temperature: serializer.fromJson<double>(json['temperature']),
      humidity: serializer.fromJson<int>(json['humidity']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      readDateTime: serializer.fromJson<DateTime>(json['dateTimeValue']),
      isSynchronized: serializer.fromJson<bool>(json['isSynchronized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'temperature': serializer.toJson<double>(temperature),
      'humidity': serializer.toJson<int>(humidity),
      'deviceId': serializer.toJson<String>(deviceId),
      'dateTimeValue': serializer.toJson<DateTime>(readDateTime),
      'isSynchronized': serializer.toJson<bool>(isSynchronized),
    };
  }

  ReadingEntityData copyWith(
          {int? id,
          double? temperature,
          int? humidity,
          String? deviceId,
          DateTime? dateTimeValue,
          bool? isSynchronized}) =>
      ReadingEntityData(
        id: id ?? this.id,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
        deviceId: deviceId ?? this.deviceId,
        readDateTime: dateTimeValue ?? this.readDateTime,
        isSynchronized: isSynchronized ?? this.isSynchronized,
      );
  @override
  String toString() {
    return (StringBuffer('ReadingEntityData(')
          ..write('id: $id, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('deviceId: $deviceId, ')
          ..write('dateTimeValue: $readDateTime, ')
          ..write('isSynchronized: $isSynchronized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, temperature, humidity, deviceId, readDateTime, isSynchronized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingEntityData &&
          other.id == this.id &&
          other.temperature == this.temperature &&
          other.humidity == this.humidity &&
          other.deviceId == this.deviceId &&
          other.readDateTime == this.readDateTime &&
          other.isSynchronized == this.isSynchronized);
}

class ReadingEntityCompanion extends UpdateCompanion<ReadingEntityData> {
  final Value<int> id;
  final Value<double> temperature;
  final Value<int> humidity;
  final Value<String> deviceId;
  final Value<DateTime> dateTimeValue;
  final Value<bool> isSynchronized;
  const ReadingEntityCompanion({
    this.id = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.dateTimeValue = const Value.absent(),
    this.isSynchronized = const Value.absent(),
  });
  ReadingEntityCompanion.insert({
    this.id = const Value.absent(),
    required double temperature,
    required int humidity,
    required String deviceId,
    required DateTime readDateTime,
    required bool isSynchronized,
  })  : temperature = Value(temperature),
        humidity = Value(humidity),
        deviceId = Value(deviceId),
        dateTimeValue = Value(readDateTime),
        isSynchronized = Value(isSynchronized);
  static Insertable<ReadingEntityData> custom({
    Expression<int>? id,
    Expression<double>? temperature,
    Expression<int>? humidity,
    Expression<String>? deviceId,
    Expression<DateTime>? dateTimeValue,
    Expression<bool>? isSynchronized,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (deviceId != null) 'device_id': deviceId,
      if (dateTimeValue != null) 'date_time_value': dateTimeValue,
      if (isSynchronized != null) 'is_synchronized': isSynchronized,
    });
  }

  ReadingEntityCompanion copyWith(
      {Value<int>? id,
      Value<double>? temperature,
      Value<int>? humidity,
      Value<String>? deviceId,
      Value<DateTime>? dateTimeValue,
      Value<bool>? isSynchronized}) {
    return ReadingEntityCompanion(
      id: id ?? this.id,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      deviceId: deviceId ?? this.deviceId,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
      isSynchronized: isSynchronized ?? this.isSynchronized,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<int>(humidity.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (dateTimeValue.present) {
      map['date_time_value'] = Variable<DateTime>(dateTimeValue.value);
    }
    if (isSynchronized.present) {
      map['is_synchronized'] = Variable<bool>(isSynchronized.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingEntityCompanion(')
          ..write('id: $id, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('deviceId: $deviceId, ')
          ..write('dateTimeValue: $dateTimeValue, ')
          ..write('isSynchronized: $isSynchronized')
          ..write(')'))
        .toString();
  }
}

class $ReadingEntityTable extends ReadingEntity
    with TableInfo<$ReadingEntityTable, ReadingEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingEntityTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  @override
  late final GeneratedColumn<double?> temperature = GeneratedColumn<double?>(
      'temperature', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _humidityMeta = const VerificationMeta('humidity');
  @override
  late final GeneratedColumn<int?> humidity = GeneratedColumn<int?>(
      'humidity', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deviceIdMeta = const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String?> deviceId = GeneratedColumn<String?>(
      'device_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateTimeValueMeta =
      const VerificationMeta('dateTimeValue');
  @override
  late final GeneratedColumn<DateTime?> dateTimeValue =
      GeneratedColumn<DateTime?>('date_time_value', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _isSynchronizedMeta =
      const VerificationMeta('isSynchronized');
  @override
  late final GeneratedColumn<bool?> isSynchronized = GeneratedColumn<bool?>(
      'is_synchronized', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_synchronized IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns =>
      [id, temperature, humidity, deviceId, dateTimeValue, isSynchronized];
  @override
  String get aliasedName => _alias ?? 'reading_entity';
  @override
  String get actualTableName => 'reading_entity';
  @override
  VerificationContext validateIntegrity(Insertable<ReadingEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('temperature')) {
      context.handle(
          _temperatureMeta,
          temperature.isAcceptableOrUnknown(
              data['temperature']!, _temperatureMeta));
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('humidity')) {
      context.handle(_humidityMeta,
          humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta));
    } else if (isInserting) {
      context.missing(_humidityMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('date_time_value')) {
      context.handle(
          _dateTimeValueMeta,
          dateTimeValue.isAcceptableOrUnknown(
              data['date_time_value']!, _dateTimeValueMeta));
    } else if (isInserting) {
      context.missing(_dateTimeValueMeta);
    }
    if (data.containsKey('is_synchronized')) {
      context.handle(
          _isSynchronizedMeta,
          isSynchronized.isAcceptableOrUnknown(
              data['is_synchronized']!, _isSynchronizedMeta));
    } else if (isInserting) {
      context.missing(_isSynchronizedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ReadingEntityData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ReadingEntityTable createAlias(String alias) {
    return $ReadingEntityTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ReadingEntityTable readingEntity = $ReadingEntityTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [readingEntity];
}
