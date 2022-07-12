import 'package:either_dart/either.dart';
import 'package:uber_app_flutter/src/data/datasources/localsource/database/data/characteristics_entity.dart';
import 'package:uber_app_flutter/src/data/entities/device_reading.dart';

import '../../core/failure/failure.dart';

abstract class ReadingRepository {
  Either<Failure, void> insertIntoDatabase(DeviceReading deviceReading);

  Either<Failure, Stream<DeviceReading?>> getLastReadingStream();

  Either<Failure, Stream<List<CharacteristicsEntity>>>
      getCharacteristicsPerDay();

  Either<Failure, Stream<int>> getCountOfNotSynchronizedReadings();

  void sendData();

  Either<Failure, Stream<List<DeviceReading?>>> getDataByDay(DateTime dateTime);
}
