import 'package:drift/drift.dart';

class ReadingEntity extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get temperature => real()();

  IntColumn get humidity => integer()();

  TextColumn get deviceId => text()();

  DateTimeColumn get dateTimeValue => dateTime()();

  BoolColumn get isSynchronized => boolean()();
}
