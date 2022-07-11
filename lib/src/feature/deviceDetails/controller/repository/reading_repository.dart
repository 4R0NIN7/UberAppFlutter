import 'package:get/get.dart';
import 'package:uber_app_flutter/src/api/api_client.dart';
import 'package:uber_app_flutter/src/database/data/characteristics_entity.dart';

import '../../../../database/database.dart';
import '../../data/device_reading.dart';

class ReadingRepository {
  final _apiClient = Get.find<FakeApiClient>();
  final _database = Get.find<MyDatabase>();

  Stream<DeviceReading> getLastReadingStream() {
    return _database.lastReading;
  }

  insertIntoDatabase(DeviceReading deviceReading) async {
    _database.insertToDatabase(deviceReading);
  }

  Stream<int> getCountOfNotSynchronizedReadings() {
    return _database.getCountNotSynchronized;
  }

  Stream<List<CharacteristicsEntity>> getCharacteristicsPerDay() {
    return _database.characteristicsPerDay;
  }

  Future<void> sendData() async {
    final dataToSend = await _database.getNotSynchronized;
    await _apiClient.sendData(dataToSend);
    _database.updateSynchronization(dataToSend);
  }

  Stream<List<DeviceReading>> getDataByDay(DateTime value) {
    return _database.getReadingsByDay(value);
  }
}
