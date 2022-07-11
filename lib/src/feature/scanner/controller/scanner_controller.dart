import 'dart:async';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerController extends GetxController {
  final isScanning = false.obs;
  final discoveredDevices = <DiscoveredDevice>[].obs;
  final _bleClient = Get.find<FlutterReactiveBle>(tag: 'BleClient');
  late StreamSubscription<DiscoveredDevice> _stream;

  void addDeviceToList(DiscoveredDevice newDevice) {
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

  void startScanning() async {
    isScanning(true);
    if (Platform.isAndroid) {
      _checkAndroidPermissions();
    }
    _stream = _bleClient.scanForDevices(
        withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
      if (device.name.isNotEmpty) {
        addDeviceToList(device);
      }
    }, onError: (error) {
      Fimber.d("Error in startScanning is $error");
    }, onDone: () {
      Fimber.d("On done startScanning");
    });
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

  void stopScanning() {
    isScanning(false);
    _stream.cancel();
    discoveredDevices.clear();
    Fimber.d("Stream was canceled!");
  }
}
