import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/api/api_client.dart';
import 'package:uber_app_flutter/src/util/dateManagement/time_manager.dart';

import '../../database/database.dart';
import '../../feature/deviceDetails/controller/repository/reading_repository.dart';
import '../../feature/scanner/controller/scanner_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<MyDatabase>(() => MyDatabase());
    Get.lazyPut<TimeManager>(() => TimeManager());
    Get.lazyPut<ScannerController>(() => ScannerController());
    Get.lazyPut<FlutterReactiveBle>(() => FlutterReactiveBle(),
        tag: 'BleClient');
    Get.lazyPut<FakeApiClient>(() => FakeApiClient());
    Get.lazyPut<ReadingRepository>(() => ReadingRepository());
  }
}
