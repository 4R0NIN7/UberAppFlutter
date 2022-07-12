import 'package:either_dart/src/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';

import '../repositories/scanning_repository.dart';

class ScanDevicesUseCase extends UseCase<Stream<DiscoveredDevice>, void> {
  final ScanningRepository _scanningRepository;

  ScanDevicesUseCase(this._scanningRepository);

  @override
  Either<Failure, Stream<DiscoveredDevice>> invoke({void params}) {
    return _scanningRepository.startScanning();
  }
}
