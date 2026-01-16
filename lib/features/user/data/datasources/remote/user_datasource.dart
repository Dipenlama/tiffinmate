import 'package:tiffinmate/features/auth/data/model/user_hive_model.dart';

abstract interface class IBatchDatasource {
  Future<List<UserHiveModel>> getAllBatches();
  Future<UserHiveModel?> getBatchById(String userId);
  Future<bool> createBatch(UserHiveModel user);
  Future<bool> updateBatch(UserHiveModel user);
  Future<bool> deleteBatch(String userId);
}