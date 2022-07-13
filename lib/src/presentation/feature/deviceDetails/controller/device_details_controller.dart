import 'package:fimber/fimber.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/domain/usecases/connect_to_device_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_characteristics_per_day_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_count_not_synchronized_readings_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_last_reading_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_readings_by_day_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/read_data_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/send_data_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/set_date_usecase.dart';

import '../../../../domain/entities/characteristics.dart';
import '../../../../domain/entities/device_reading.dart';

class DeviceDetailsController extends GetxController {
  final ConnectToDeviceUseCase _connectToDeviceUseCase =
      Get.find<ConnectToDeviceUseCase>();
  final SetDateUseCase _setDateUseCase = Get.find<SetDateUseCase>();
  final ReadDataUseCase _readDataUseCase = Get.find<ReadDataUseCase>();
  final GetLastReadingUseCase _getLastReadingUseCase =
      Get.find<GetLastReadingUseCase>();
  final GetCountNotSynchronizedUseCase _getCountNotSynchronizedUseCase =
      Get.find<GetCountNotSynchronizedUseCase>();
  final SendDataUseCase _sendDataUseCase = Get.find<SendDataUseCase>();
  final GetCharacteristicsPerDay _getCharacteristicsPerDay =
      Get.find<GetCharacteristicsPerDay>();
  final GetReadingsByDayUseCase _getReadingsByDayUseCase =
      Get.find<GetReadingsByDayUseCase>();
  late final DiscoveredDevice _discoveredDevice;
  final String _dateService = "fd8136b0-f18f-4f36-ad03-c73311525a80";
  final String _dateCharacteristic = "fd8136b1-f18f-4f36-ad03-c73311525a80";
  final String _readingsService = "fd8136c0-f18f-4f36-ad03-c73311525a80";
  final String _readingsCharacteristic = "fd8136c1-f18f-4f36-ad03-c73311525a80";
  final _isConnected = false.obs;
  final Rxn<ConnectionStateUpdate> _connectionState = Rxn();
  Rxn<DeviceReading> lastReading = Rxn<DeviceReading>();
  Rx<int> countNotSynchronized = Rx<int>(0);
  Rx<List<Characteristics>> characteristicsPerDay =
      Rx<List<Characteristics>>(List.empty());
  Rx<List<DeviceReading>> readingsByDay = Rx<List<DeviceReading>>(List.empty());

  DeviceDetailsController({required DiscoveredDevice discoveredDevice}) {
    _discoveredDevice = discoveredDevice;
  }

  @override
  void onInit() {
    super.onInit();
    _bindLastReadingStream();
    _bindCountStream();
    _bindCharacteristicsStream();
  }

  @override
  void onReady() {
    super.onReady();
    _connectToDevice();
    _handleSendingData();
  }

  void _connectToDevice() {
    _connectToDeviceUseCase.invoke(params: _discoveredDevice).fold(
        (left) => Fimber.d("_connectToDevice ${left.message}"),
        (right) => _connectionState.bindStream(right));
    _handleConnectionState();
  }

  _handleConnectionState() async {
    _connectionState.listen((connectionState) async {
      switch (connectionState!.connectionState) {
        case DeviceConnectionState.connecting:
          {
            Fimber.d("Connecting to device");
            break;
          }
        case DeviceConnectionState.connected:
          {
            Fimber.d("Connected to device");
            _isConnected(true);
            await _handleDate();
            _readData();
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            Fimber.d("Disconnecting from device");
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            Fimber.d("Disconnected from device");
            _isConnected(false);
            break;
          }
      }
    }, onError: (dynamic error) {
      // Handle a possible error
    });
  }

  _readData() async {
    final readingsCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(_readingsService),
        characteristicId: Uuid.parse(_readingsCharacteristic),
        deviceId: _discoveredDevice.id);
    final result = _readDataUseCase.invoke(params: readingsCharacteristic);
    result.fold((left) => Fimber.d(left.message),
        (right) => Fimber.d("Subscribed to device successfully"));
  }

  Future<void> _handleDate() async {
    final dateCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(_dateService),
        characteristicId: Uuid.parse(_dateCharacteristic),
        deviceId: _discoveredDevice.id);
    if (_isConnected.isTrue) {
      final result = await _setDateUseCase.invoke(params: dateCharacteristic);
      result.fold((left) => Fimber.d(left.message),
          (right) => Fimber.d("Date was set successfully"));
    }
  }

  _bindLastReadingStream() {
    try {
      final result = _getLastReadingUseCase.invoke(params: null);
      result.fold((left) => Fimber.d(left.message),
          (right) => lastReading.bindStream(right));
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  _bindCountStream() {
    try {
      final result = _getCountNotSynchronizedUseCase.invoke(params: null);
      result.fold((left) => Fimber.d(left.message),
          (right) => countNotSynchronized.bindStream(right));
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  _bindCharacteristicsStream() {
    try {
      final result = _getCharacteristicsPerDay.invoke(params: null);
      result.fold((left) => Fimber.d(left.message),
          (right) => characteristicsPerDay.bindStream(right));
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  getReadingsByDay(DateTime dateTime) {
    final result = _getReadingsByDayUseCase.invoke(params: dateTime);
    result.fold((left) => Fimber.d(left.message),
        (right) => readingsByDay.bindStream(right));
    _handleReadingsByDay();
  }

  _handleReadingsByDay() {
    readingsByDay.listen((event) {
      Fimber.d("Size is ${event.length}\nValues are $event");
    });
  }

  _handleSendingData() async {
    countNotSynchronized.listen((count) async {
      Fimber.d("Count is $count");
      if (count >= 20) {
        final result = await _sendDataUseCase.invoke(params: null);
        result.fold((left) => Fimber.d(left.message),
            (right) => Fimber.d("Data has been sent"));
      }
    });
  }
}
