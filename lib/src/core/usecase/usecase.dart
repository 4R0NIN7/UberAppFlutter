import 'package:either_dart/either.dart';

import '../failure/failure.dart';

abstract class UseCase<T, P> {
  Either<Failure, T> invoke({required P params});
}

abstract class FutureUseCase<T, P> {
  Future<Either<Failure, T>> invoke({required P params});
}
