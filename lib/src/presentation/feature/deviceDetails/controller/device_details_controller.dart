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
  final String _dateService = "fd8136b0-f18f-4f36-ad03-c73311525a80";
  final String _dateCharacteristic = "fd8136b1-f18f-4f36-ad03-c73311525a80";
  final String _readingsService = "fd8136c0-f18f-4f36-ad03-c73311525a80";
  final String _readingsCharacteristic = "fd8136c1-f18f-4f36-ad03-c73311525a80";

  late ConnectToDeviceUseCase _connectToDeviceUseCase;
  late SetDateUseCase _setDateUseCase;
  late ReadDataUseCase _readDataUseCase;
  late GetLastReadingUseCase _getLastReadingUseCase;
  late GetCountNotSynchronizedUseCase _getCountNotSynchronizedUseCase;
  late SendDataUseCase _sendDataUseCase;
  late GetCharacteristicsPerDay _getCharacteristicsPerDay;
  late GetReadingsByDayUseCase _getReadingsByDayUseCase;

  final _isConnected = false.obs;
  final Rxn<ConnectionStateUpdate> _connectionState =
      Rxn<ConnectionStateUpdate>();
  Rxn<DeviceReading> lastReading = Rxn<DeviceReading>();
  Rx<int> countNotSynchronized = Rx<int>(0);
  Rx<List<Characteristics>> characteristicsPerDay =
      Rx<List<Characteristics>>(List.empty());
  Rx<List<DeviceReading>> readingsByDay = Rx<List<DeviceReading>>(List.empty());

  DeviceDetailsController(
      {required ConnectToDeviceUseCase connectToDeviceUseCase,
      required SetDateUseCase setDateUseCase,
      required ReadDataUseCase readDataUseCase,
      required GetLastReadingUseCase getLastReadingUseCase,
      required GetCountNotSynchronizedUseCase getCountNotSynchronizedUseCase,
      required SendDataUseCase sendDataUseCase,
      required GetCharacteristicsPerDay getCharacteristicsPerDay,
      required GetReadingsByDayUseCase getReadingsByDayUseCase}) {
    _getReadingsByDayUseCase = getReadingsByDayUseCase;
    _getCharacteristicsPerDay = getCharacteristicsPerDay;
    _getCountNotSynchronizedUseCase = getCountNotSynchronizedUseCase;
    _sendDataUseCase = sendDataUseCase;
    _setDateUseCase = setDateUseCase;
    _readDataUseCase = readDataUseCase;
    _connectToDeviceUseCase = connectToDeviceUseCase;
    _getLastReadingUseCase = getLastReadingUseCase;
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
    final discoveredDevice = Get.find<DiscoveredDevice>();
    Fimber.d("_connectToDevice");
    _connectToDeviceUseCase
        .invoke(params: discoveredDevice)
        .fold((left) => Fimber.d("_connectToDevice ${left.message}"), (right) {
      Fimber.d("Stream is going to be bound");
      _connectionState.bindStream(right);
      Fimber.d(
          "_connectToDevice stream is bound. Value is ${_connectionState.value}");
      Fimber.d("Discovered device is $discoveredDevice");
      _handleConnectionState();
    });
  }

  _handleConnectionState() {
    Fimber.d("_handleConnectionState");
    _connectionState.listen((connectionState) {
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
            _handleDate();
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
    final discoveredDevice = Get.find<DiscoveredDevice>();
    final readingsCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(_readingsService),
        characteristicId: Uuid.parse(_readingsCharacteristic),
        deviceId: discoveredDevice.id);
    final result = _readDataUseCase.invoke(params: readingsCharacteristic);
    result.fold((left) => Fimber.d(left.message),
        (right) => Fimber.d("Subscribed to device successfully"));
  }

  Future<void> _handleDate() async {
    final discoveredDevice = Get.find<DiscoveredDevice>();
    final dateCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(_dateService),
        characteristicId: Uuid.parse(_dateCharacteristic),
        deviceId: discoveredDevice.id);
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

  logout() {
    readingsByDay.close();
    countNotSynchronized.close();
    characteristicsPerDay.close();
    _connectionState.close();
    Fimber.d("Disconnected from device!");
  }
}
