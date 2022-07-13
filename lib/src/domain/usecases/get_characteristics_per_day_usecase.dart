import 'package:either_dart/src/either.dart';
import 'package:uber_app_flutter/src/core/failure/failure.dart';
import 'package:uber_app_flutter/src/core/usecase/usecase.dart';
import 'package:uber_app_flutter/src/domain/entities/characteristics.dart';

import '../repositories/device_details_repository.dart';

class GetCharacteristicsPerDay
    extends UseCase<Stream<List<Characteristics>>, void> {
  final DeviceDetailsRepository _deviceDetailsRepository;

  GetCharacteristicsPerDay(this._deviceDetailsRepository);
  @override
  Either<Failure, Stream<List<Characteristics>>> invoke(
      {required void params}) {
    return _deviceDetailsRepository.getCharacteristicsPerDay();
  }
}
