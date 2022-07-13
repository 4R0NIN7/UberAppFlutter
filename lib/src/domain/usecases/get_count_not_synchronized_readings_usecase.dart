import 'package:either_dart/src/either.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';
import 'package:uber_app_flutter/src/domain/repositories/device_details_repository.dart';

class GetCountNotSynchronizedUseCase extends UseCase<Stream<int>, void> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  GetCountNotSynchronizedUseCase(this._deviceDetailsRepository);
  @override
  Either<Failure, Stream<int>> invoke({required void params}) {
    return _deviceDetailsRepository.getCountOfNotSynchronizedReadings();
  }
}
