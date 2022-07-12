import 'dart:io';

import 'package:either_dart/src/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reactive_ble_platform_interface/src/model/discovered_device.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/domain/repositories/scanning_repository.dart';

class ScanningRepositoryImpl implements ScanningRepository {
  final _bleClient = Get.find<FlutterReactiveBle>(tag: 'BleClient');

  @override
  Either<Failure, Stream<DiscoveredDevice>> startScanning() {
    if (Platform.isAndroid) {
      _checkAndroidPermissions();
    }
    try {
      final resultStream = _bleClient
          .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency);
      return Right(resultStream);
    } on Exception catch (error) {
      return Left(ScanningFailure("$error"));
    }
  }

  Future<void> _checkAndroidPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
  }
}
