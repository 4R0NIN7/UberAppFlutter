import 'package:either_dart/src/either.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';

import '../entities/device_reading.dart';
import '../repositories/device_details_repository.dart';

class GetLastReadingUseCase extends UseCase<Stream<DeviceReading>, void> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  GetLastReadingUseCase(this._deviceDetailsRepository);

  @override
  Either<Failure, Stream<DeviceReading>> invoke({required void params}) {
    return _deviceDetailsRepository.getLastReading();
  }
}
