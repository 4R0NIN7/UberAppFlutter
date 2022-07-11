import 'package:fimber/fimber.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/proto/Readings.pb.dart';
import 'package:uber_app_flutter/src/feature/deviceDetails/controller/repository/reading_repository.dart';
import 'package:uber_app_flutter/src/feature/deviceDetails/data/characteristics.dart';
import 'package:uber_app_flutter/src/feature/deviceDetails/data/device_reading.dart';
import 'package:uber_app_flutter/src/util/functions.dart';

import '../../../util/dateManagement/time_manager.dart';

class DeviceDetailsController extends GetxController {
  final _bleClient = Get.find<FlutterReactiveBle>(tag: 'BleClient');
  final _timeManager = Get.find<TimeManager>();
  final _readingRepository = Get.find<ReadingRepository>();
  final String _dateService = "fd8136b0-f18f-4f36-ad03-c73311525a80";
  final String _dateCharacteristic = "fd8136b1-f18f-4f36-ad03-c73311525a80";
  final String _readingsService = "fd8136c0-f18f-4f36-ad03-c73311525a80";
  final String _readingsCharacteristic = "fd8136c1-f18f-4f36-ad03-c73311525a80";
  final _isConnected = false.obs;
  Rxn<DeviceReading> lastReading = Rxn<DeviceReading>();
  Rx<int> countNotSynchronized = Rx<int>(0);
  Rx<List<Characteristics>> characteristicsPerDay =
      Rx<List<Characteristics>>(List.empty());

  DiscoveredDevice discoveredDevice;

  DeviceDetailsController(this.discoveredDevice);

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

  void _connectToDevice() async {
    _bleClient
        .connectToAdvertisingDevice(
      id: discoveredDevice.id,
      withServices: [],
      prescanDuration: const Duration(seconds: 5),
      servicesWithCharacteristicsToDiscover: {},
      connectionTimeout: const Duration(seconds: 2),
    ).listen((connectionState) {
      switch (connectionState.connectionState) {
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
    final readingsCharacteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(_readingsService),
        characteristicId: Uuid.parse(_readingsCharacteristic),
        deviceId: discoveredDevice.id);
    _bleClient.subscribeToCharacteristic(readingsCharacteristic).listen((data) {
      final reading = Readings.fromBuffer(data);
      final deviceReading = DeviceReading(
          humidity: reading.hummidity,
          temperature: reading.temperature,
          readDateTime: _timeManager.getNow(),
          deviceId: discoveredDevice.id,
          isSynchronized: false);
      _readingRepository.insertIntoDatabase(deviceReading);
    }, onError: (dynamic error) {
      Fimber.d("Error during readings Error is $error");
    });
  }

  Future<void> _handleDate() async {
    try {
      final dateCharacteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse(_dateService),
          characteristicId: Uuid.parse(_dateCharacteristic),
          deviceId: discoveredDevice.id);
      if (_isConnected.isTrue) {
        final dateFromDeviceBytes =
            await _bleClient.readCharacteristic(dateCharacteristic);
        var yearFromBytesToInt =
            fromBytesToIntYear(dateFromDeviceBytes[3], dateFromDeviceBytes[2]);
        var dateOnDeviceDateTime = DateTime(
            yearFromBytesToInt, dateFromDeviceBytes[1], dateFromDeviceBytes[0]);
        _checkDate(dateOnDeviceDateTime);
      }
    } on Exception catch (error) {
      Fimber.d("Error is $error");
    }
  }

  void _checkDate(DateTime dateTimeOnDevice) {
    var now = _timeManager.getNow();
    try {
      if (!now.isSameDate(dateTimeOnDevice)) {
        var dateToBytes = now.dateToBytes();
        final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(_dateService),
            characteristicId: Uuid.parse(_dateCharacteristic),
            deviceId: discoveredDevice.id);
        if (_isConnected.isTrue) {
          _bleClient.writeCharacteristicWithResponse(characteristic,
              value: dateToBytes);
        }
      }
    } on Exception catch (error) {
      Fimber.d("Error is $error");
    }
  }

  _bindLastReadingStream() {
    try {
      lastReading.bindStream(_readingRepository.getLastReadingStream());
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  _bindCountStream() {
    try {
      countNotSynchronized
          .bindStream(_readingRepository.getCountOfNotSynchronizedReadings());
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  _bindCharacteristicsStream() {
    try {
      characteristicsPerDay.bindStream(_readingRepository
          .getCharacteristicsPerDay()
          .map((event) => event
              .map((e) => Characteristics(
                  averageTemperature: e.averageTemperature,
                  minimalTemperature: e.minimalTemperature,
                  maximalTemperature: e.maximalTemperature,
                  averageHumidity: e.averageHumidity,
                  minimalHumidity: e.minimalHumidity,
                  maximalHumidity: e.maximalHumidity,
                  day: e.dateTimeValue))
              .toList()));
    } catch (e) {
      Fimber.d("Error in binding $e");
    }
  }

  getReadingsByDay(DateTime dateTime) {
    _readingRepository.getDataByDay(dateTime).listen((event) {
      Fimber.d("Size is ${event.length}\nValues are $event");
    });
  }

  _handleSendingData() {
    countNotSynchronized.listen((count) {
      Fimber.d("Count is $count");
      if (count >= 20) {
        _readingRepository.sendData();
      }
    });
  }
}
