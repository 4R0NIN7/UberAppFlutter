import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uber_app_flutter/src/core/util/functions.dart';

import '../../../../domain/entities/device_reading.dart';
import '../../../entities/characteristics_entity.dart';
import '../../../entities/reading_entity.dart';
import 'database_const.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ReadingEntity])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => version;

  Stream<DeviceReading> get lastReading {
    return (select(readingEntity)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..limit(1))
        .map((entity) => DeviceReading(
            humidity: entity.humidity,
            temperature: entity.temperature,
            readDateTime: entity.readDateTime,
            deviceId: entity.deviceId,
            isSynchronized: entity.isSynchronized))
        .watchSingle();
  }

  Stream<List<CharacteristicsEntity>> get characteristicsPerDay {
    final minTemperature = readingEntity.temperature.min();
    final avgTemperature = readingEntity.temperature.avg();
    final maxTemperature = readingEntity.temperature.max();
    final minHumidity = readingEntity.humidity.min();
    final avgHumidity = readingEntity.humidity.avg();
    final maxHumidity = readingEntity.humidity.max();
    final query = selectOnly(readingEntity)
      ..addColumns([
        minTemperature,
        avgTemperature,
        maxTemperature,
        minHumidity,
        avgHumidity,
        maxHumidity,
        readingEntity.dateTimeValue
      ])
      ..groupBy([readingEntity.dateTimeValue.date]);
    return query
        .map((row) => CharacteristicsEntity(
            averageTemperature: row.read(avgTemperature)!,
            minimalTemperature: row.read(minTemperature)!,
            maximalTemperature: row.read(maxTemperature)!,
            averageHumidity: row.read(avgHumidity)!,
            minimalHumidity: row.read(minHumidity)!,
            maximalHumidity: row.read(maxHumidity)!,
            dateTimeValue: row.read(readingEntity.dateTimeValue)!))
        .watch();
  }

  Stream<List<DeviceReading>> getReadingsByDay(DateTime value) {
    return (select(readingEntity)
          ..where((tbl) {
            final dateInDatabase =
                tbl.dateTimeValue.date.equals(value.toDateString());
            return dateInDatabase;
          }))
        .map((entity) => DeviceReading(
            humidity: entity.humidity,
            temperature: entity.temperature,
            readDateTime: entity.readDateTime,
            deviceId: entity.deviceId,
            isSynchronized: entity.isSynchronized))
        .watch();
  }

  Stream<int> get getCountNotSynchronized {
    final countNotSynchronized = readingEntity.id.count();
    final query = selectOnly(readingEntity)
      ..addColumns([countNotSynchronized])
      ..where(readingEntity.isSynchronized.equals(false));
    return query.map((row) => row.read(countNotSynchronized)).watchSingle();
  }

  Future<List<ReadingEntityData>> get getNotSynchronized {
    return (select(readingEntity)
          ..where((tbl) => tbl.isSynchronized.equals(false)))
        .get();
  }

  insertToDatabase(DeviceReading deviceReading) {
    var entry = ReadingEntityCompanion.insert(
        temperature: deviceReading.temperature,
        humidity: deviceReading.humidity,
        deviceId: deviceReading.deviceId,
        readDateTime: deviceReading.readDateTime,
        isSynchronized: deviceReading.isSynchronized);
    into(readingEntity).insertOnConflictUpdate(entry);
  }

  updateSynchronization(List<ReadingEntityData> dataToSend) async {
    var rows = dataToSend.map((e) => ReadingEntityData(
        id: e.id,
        temperature: e.temperature,
        humidity: e.humidity,
        deviceId: e.deviceId,
        readDateTime: e.readDateTime,
        isSynchronized: true));
    await batch((batch) {
      batch.insertAllOnConflictUpdate(readingEntity, rows);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
