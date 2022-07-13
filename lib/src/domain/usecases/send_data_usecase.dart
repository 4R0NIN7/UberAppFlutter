import 'package:either_dart/src/either.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';

import '../repositories/device_details_repository.dart';

class SendDataUseCase extends FutureUseCase<bool, void> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  SendDataUseCase(this._deviceDetailsRepository);

  @override
  Future<Either<Failure, bool>> invoke({required void params}) {
    return _deviceDetailsRepository.sendData();
  }
}
