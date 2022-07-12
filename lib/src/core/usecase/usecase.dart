import 'package:either_dart/either.dart';

import '../failure/failure.dart';

abstract class UseCase<T, P> {
  Either<Failure, T> invoke({P params});
}
