import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/user/domain/entities/user_entity.dart';


abstract interface class IBatchRepository {
  Future<Either<Failure, List<BatchEntity>>> getAllBatches();
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId);
  Future<Either<Failure, bool>> createBatch(BatchEntity batch);
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch);
  Future<Either<Failure, bool>> deleteBatch(String batchId);
}