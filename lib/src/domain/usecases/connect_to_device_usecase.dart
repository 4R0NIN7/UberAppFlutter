import 'package:either_dart/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';
import 'package:uber_app_flutter/src/domain/repositories/device_details_repository.dart';

class ConnectToDeviceUseCase
    implements UseCase<Stream<ConnectionStateUpdate>, DiscoveredDevice> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  ConnectToDeviceUseCase(this._deviceDetailsRepository);

  @override
  Either<Failure, Stream<ConnectionStateUpdate>> invoke(
      {required DiscoveredDevice params}) {
    return _deviceDetailsRepository.connectToDevice(params);
  }
}
