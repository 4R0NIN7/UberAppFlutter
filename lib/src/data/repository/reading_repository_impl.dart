import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/api/api_client.dart';
import 'package:uber_app_flutter/src/domain/repositories/reading_repository.dart';

import '../../core/failure/failure.dart';
import '../datasources/localsource/database/data/characteristics_entity.dart';
import '../datasources/localsource/database/database.dart';
import '../entities/device_reading.dart';

class ReadingRepositoryImpl extends ReadingRepository {
  final _apiClient = Get.find<FakeApiClient>();
  final _database = Get.find<MyDatabase>();

  @override
  Either<Failure, Stream<DeviceReading>> getLastReadingStream() {
    return Right(_database.lastReading);
  }

  @override
  Either<Failure, void> insertIntoDatabase(DeviceReading deviceReading) {
    return _database.insertToDatabase(deviceReading);
  }

  @override
  Either<Failure, Stream<int>> getCountOfNotSynchronizedReadings() {
    return Right(_database.getCountNotSynchronized);
  }

  @override
  Either<Failure, Stream<List<CharacteristicsEntity>>>
      getCharacteristicsPerDay() {
    return Right(_database.characteristicsPerDay);
  }

  @override
  Future<void> sendData() async {
    final dataToSend = await _database.getNotSynchronized;
    await _apiClient.sendData(dataToSend);
    _database.updateSynchronization(dataToSend);
  }

  @override
  Stream<List<DeviceReading>> getDataByDay(DateTime value) {
    return _database.getReadingsByDay(value);
  }
}
