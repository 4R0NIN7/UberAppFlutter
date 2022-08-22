import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uber_app_flutter/src/domain/usecases/scan_devices_usecase.dart';
import 'package:uber_app_flutter/src/presentation/feature/scanner/controller/scanner_controller.dart';

import 'scanner_controller_test.mocks.dart';

@GenerateMocks([DiscoveredDevice, StartScanningDevicesUseCase], customMocks: [])
void main() {
  setUp(() {});
  test('''Start scanning''', () {
    final scanDevicesUseCase = MockStartScanningDevicesUseCase();
    final discoveredDevice = MockDiscoveredDevice();
    final stream = Stream.fromIterable(([discoveredDevice]));
    final controller =
        ScannerController(scanDevicesUseCase: scanDevicesUseCase);
    when(discoveredDevice.name).thenReturn("Device");
    when(scanDevicesUseCase.invoke()).thenAnswer((_) => Right(stream));
    Get.put(controller);

    expect(controller.isScanning.value, true);
    expect(controller.streamSubscription.isPaused, false);
  });
  test('''pause scanning''', () {
    final scanDevicesUseCase = MockStartScanningDevicesUseCase();
    final controller =
        ScannerController(scanDevicesUseCase: scanDevicesUseCase);
    final discoveredDevice = MockDiscoveredDevice();
    final stream = Stream.fromIterable(([discoveredDevice]));
    when(discoveredDevice.name).thenReturn("Device");
    when(scanDevicesUseCase.invoke()).thenAnswer((_) => Right(stream));
    Get.put(controller);
    controller.startScanning();
    controller.pauseScanning();
    expect(controller.streamSubscription.isPaused, true);
    expect(controller.isScanning.value, false);
  });
  test('''stop scanning''', () {
    final scanDevicesUseCase = MockStartScanningDevicesUseCase();
    final controller =
        ScannerController(scanDevicesUseCase: scanDevicesUseCase);
    final discoveredDevice = MockDiscoveredDevice();
    final stream = Stream.fromIterable(([discoveredDevice]));
    when(discoveredDevice.name).thenReturn("Device");
    when(scanDevicesUseCase.invoke()).thenAnswer((_) => Right(stream));
    Get.put(controller);
    controller.startScanning();
    controller.stopScanning();
    expect(controller.isScanning.value, false);
  });
}
