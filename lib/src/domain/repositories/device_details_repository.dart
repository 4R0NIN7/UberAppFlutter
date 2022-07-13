import 'package:either_dart/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:reactive_ble_platform_interface/src/model/connection_state_update.dart';
import 'package:reactive_ble_platform_interface/src/model/discovered_device.dart';
import 'package:uber_app_flutter/src/domain/entities/characteristics.dart';
import 'package:uber_app_flutter/src/domain/entities/device_reading.dart';

import '../../core/failure/failure.dart';

abstract class DeviceDetailsRepository {
  Either<Failure, bool> readData(
      QualifiedCharacteristic qualifiedCharacteristic);

  Either<Failure, Stream<DeviceReading>> getLastReading();

  Either<Failure, Stream<List<Characteristics>>> getCharacteristicsPerDay();

  Either<Failure, Stream<int>> getCountOfNotSynchronizedReadings();

  Future<Either<Failure, bool>> sendData();

  Either<Failure, Stream<List<DeviceReading>>> getDataByDay(DateTime dateTime);

  Either<Failure, Stream<ConnectionStateUpdate>> connectToDevice(
      DiscoveredDevice discoveredDevice);

  Future<Either<Failure, void>> handleDate(
      QualifiedCharacteristic qualifiedCharacteristic);
}
