import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/api/api_client.dart';
import 'package:uber_app_flutter/src/data/repository/reading_repository_impl.dart';
import 'package:uber_app_flutter/src/data/repository/scanning_repository_impl.dart';
import 'package:uber_app_flutter/src/domain/repositories/scanning_repository.dart';

import '../../../data/datasources/localsource/database/database.dart';
import '../../../domain/repositories/reading_repository.dart';
import '../../../domain/usecases/scan_devices_usecase.dart';
import '../../../presentation/feature/scanner/controller/scanner_controller.dart';
import '../dateManagement/time_manager.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() async {
    _setDependencies();
    _setRepositories();
    _setUseCases();
    _setControllers();
  }

  _setRepositories() {
    Get.lazyPut<ScanningRepository>(() => ScanningRepositoryImpl());
    Get.lazyPut<ReadingRepository>(() => ReadingRepositoryImpl());
  }

  _setControllers() {
    final scanDevicesUseCase = Get.find<ScanDevicesUseCase>();
    Get.lazyPut<ScannerController>(
        () => ScannerController(scanDevicesUseCase: scanDevicesUseCase));
  }

  _setUseCases() {
    final scanningRepository = Get.find<ScanningRepository>();
    Get.lazyPut<ScanDevicesUseCase>(
        () => ScanDevicesUseCase(scanningRepository));
  }

  _setDependencies() {
    Get.lazyPut<FlutterReactiveBle>(() => FlutterReactiveBle(),
        tag: 'BleClient');
    Get.lazyPut<FakeApiClient>(() => FakeApiClient());
    Get.lazyPut<MyDatabase>(() => MyDatabase());
    Get.lazyPut<TimeManager>(() => TimeManager());
  }
}
