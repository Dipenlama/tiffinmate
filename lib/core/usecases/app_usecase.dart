import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';

abstract interface class UsecaseWithParms<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UsecaseWithoutParms<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
