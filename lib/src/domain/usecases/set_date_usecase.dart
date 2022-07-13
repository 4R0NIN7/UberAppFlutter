import 'package:either_dart/src/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';
import 'package:uber_app_flutter/src/domain/repositories/device_details_repository.dart';

class SetDateUseCase implements FutureUseCase<void, QualifiedCharacteristic> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  SetDateUseCase(this._deviceDetailsRepository);

  @override
  Future<Either<Failure, void>> invoke(
      {required QualifiedCharacteristic params}) {
    return _deviceDetailsRepository.handleDate(params);
  }
}
