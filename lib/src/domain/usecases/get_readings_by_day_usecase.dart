import 'package:either_dart/src/either.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';

import '../entities/device_reading.dart';
import '../repositories/device_details_repository.dart';

class GetReadingsByDayUseCase
    extends UseCase<Stream<List<DeviceReading>>, DateTime> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  GetReadingsByDayUseCase(this._deviceDetailsRepository);

  @override
  Either<Failure, Stream<List<DeviceReading>>> invoke({required params}) {
    return _deviceDetailsRepository.getDataByDay(params);
  }
}
