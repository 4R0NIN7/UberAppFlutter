import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/api/api_client.dart';
import 'package:uber_app_flutter/src/core/util/dateManagement/time_manager.dart';
import 'package:uber_app_flutter/src/domain/entities/characteristics.dart';
import 'package:uber_app_flutter/src/domain/repositories/device_details_repository.dart';

import '../../../proto/Readings.pb.dart';
import '../../core/failure/failure.dart';
import '../../core/util/functions.dart';
import '../../domain/entities/device_reading.dart';
import '../datasources/localsource/database/database.dart';

class DeviceDetailsRepositoryImpl implements DeviceDetailsRepository {
  final _apiClient = Get.find<FakeApiClient>();
  final _database = Get.find<MyDatabase>();
  final _bleClient = Get.find<FlutterReactiveBle>(tag: 'BleClient');
  final _timeManager = Get.find<TimeManager>();
  late final Stream<List<int>> _readDataStream;

  @override
  Either<Failure, bool> readData(
      QualifiedCharacteristic qualifiedCharacteristic) {
    try {
      _readDataStream =
          _bleClient.subscribeToCharacteristic(qualifiedCharacteristic);
      _handleReadings(qualifiedCharacteristic);
      return const Right(true);
    } on Exception catch (error) {
      return Left(ConnectionFailure("$error"));
    }
  }

  _handleReadings(QualifiedCharacteristic qualifiedCharacteristic) {
    try {
      _readDataStream.listen((data) {
        final reading = Readings.fromBuffer(data);
        final deviceReading = DeviceReading(
            humidity: reading.hummidity,
            temperature: reading.temperature,
            readDateTime: _timeManager.getNow(),
            deviceId: qualifiedCharacteristic.deviceId,
            isSynchronized: false);
        _insertIntoDatabase(deviceReading);
      }, onError: (dynamic error) {
        throw Exception;
      });
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }

  _insertIntoDatabase(DeviceReading deviceReading) {
    _database.insertToDatabase(deviceReading);
  }

  @override
  Either<Failure, Stream<int>> getCountOfNotSynchronizedReadings() {
    try {
      return Right(_database.getCountNotSynchronized);
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }

  @override
  Either<Failure, Stream<List<Characteristics>>> getCharacteristicsPerDay() {
    try {
      return Right(_database.characteristicsPerDay.map((list) => list
          .map((characteristicEntity) => Characteristics(
              averageTemperature: characteristicEntity.averageTemperature,
              minimalTemperature: characteristicEntity.minimalTemperature,
              maximalTemperature: characteristicEntity.maximalTemperature,
              averageHumidity: characteristicEntity.averageHumidity,
              minimalHumidity: characteristicEntity.minimalHumidity,
              maximalHumidity: characteristicEntity.maximalHumidity,
              day: characteristicEntity.dateTimeValue))
          .toList()));
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, bool>> sendData() async {
    try {
      final dataToSend = await _database.getNotSynchronized;
      await _apiClient.sendData(dataToSend);
      await _database.updateSynchronization(dataToSend);
      return const Right(true);
    } on SocketException catch (error) {
      return Left(ConnectionFailure("$error"));
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }

  @override
  Either<Failure, Stream<List<DeviceReading>>> getDataByDay(DateTime value) {
    try {
      return Right(_database.getReadingsByDay(value));
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }

  @override
  Either<Failure, Stream<ConnectionStateUpdate>> connectToDevice(
      DiscoveredDevice discoveredDevice) {
    try {
      final connection = _bleClient.connectToAdvertisingDevice(
        id: discoveredDevice.id,
        withServices: [],
        prescanDuration: const Duration(seconds: 5),
        servicesWithCharacteristicsToDiscover: {},
        connectionTimeout: const Duration(seconds: 2),
      );
      return Right(connection);
    } on Exception catch (error) {
      return Left(ConnectionFailure("$error"));
    }
  }

  @override
  Future<Either<Failure, void>> handleDate(
      QualifiedCharacteristic qualifiedCharacteristic) async {
    try {
      final dateFromDeviceBytes =
          await _bleClient.readCharacteristic(qualifiedCharacteristic);
      var yearFromBytesToInt =
          fromBytesToIntYear(dateFromDeviceBytes[3], dateFromDeviceBytes[2]);
      var dateOnDeviceDateTime = DateTime(
          yearFromBytesToInt, dateFromDeviceBytes[1], dateFromDeviceBytes[0]);
      return Right(_checkDate(dateOnDeviceDateTime, qualifiedCharacteristic));
    } on Exception catch (error) {
      return Left(ConnectionFailure("$error"));
    }
  }

  void _checkDate(DateTime dateTimeOnDevice,
      QualifiedCharacteristic qualifiedCharacteristic) {
    var now = _timeManager.getNow();
    try {
      if (!now.isSameDate(dateTimeOnDevice)) {
        var dateToBytes = now.dateToBytes();
        _bleClient.writeCharacteristicWithResponse(qualifiedCharacteristic,
            value: dateToBytes);
      }
    } on Exception {
      rethrow;
    }
  }

  @override
  Either<Failure, Stream<DeviceReading>> getLastReading() {
    try {
      return Right(_database.lastReading);
    } on Exception catch (error) {
      return Left(DatabaseFailure("$error"));
    }
  }
}
