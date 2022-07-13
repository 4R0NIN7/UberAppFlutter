import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/domain/usecases/scan_devices_usecase.dart';

class ScannerController extends GetxController {
  late StartScanningDevicesUseCase _scanDevicesUseCase;
  final isScanning = false.obs;
  final _isFirstTime = true.obs;
  final discoveredDevices = [].obs;
  final Rxn<DiscoveredDevice> _discoveredDevice = Rxn();
  late final StreamSubscription<DiscoveredDevice?> streamSubscription;

  ScannerController({required StartScanningDevicesUseCase scanDevicesUseCase}) {
    _scanDevicesUseCase = scanDevicesUseCase;
  }

  void _addDeviceToList(DiscoveredDevice newDevice) {
    var existingDeviceInList = discoveredDevices
        .firstWhereOrNull((element) => element.name == newDevice.name);
    if (existingDeviceInList == null) {
      discoveredDevices.add(newDevice);
      _sortListByRssi();
    } else {
      discoveredDevices.remove(existingDeviceInList);
      discoveredDevices.add(newDevice);
      _sortListByRssi();
    }
  }

  void _sortListByRssi() {
    discoveredDevices.sort((a, b) {
      return b.rssi.compareTo(a.rssi);
    });
  }

  startScanning() {
    if (_isFirstTime.isFalse) {
      streamSubscription.resume();
      isScanning(true);
    } else {
      final result = _scanDevicesUseCase.invoke();
      result.fold((left) => Fimber.d(left.message), (right) {
        _discoveredDevice.bindStream(right);
      });
      isScanning(true);
      _isFirstTime(false);
      _observeNewDevice();
    }
  }

  _observeNewDevice() {
    streamSubscription = _discoveredDevice.listen((device) {
      if (device!.name.isNotEmpty) {
        _addDeviceToList(device);
      }
    });
  }

  void stopScanning() {
    streamSubscription.pause();
    discoveredDevices.clear();
    isScanning(false);
  }
}
