import 'package:either_dart/either.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../core/failure/failure.dart';

abstract class ScanningRepository {
  Either<Failure, Stream<DiscoveredDevice>> startScanning();
}
