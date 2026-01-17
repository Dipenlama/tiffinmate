
import 'package:tiffinmate/core/constants/hive_table_constant.dart';
import 'package:tiffinmate/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';




part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.userTypeId)

class AuthHiveModel extends HiveObject{
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;
  
  @HiveField(4)
  final String? confirmPassword;



  AuthHiveModel({
    String? authId,
    required this.email,
    this.password, 
    required this.username,
     this.confirmPassword,
  }) : authId = authId ?? Uuid().v4();

  // To Entity
  AuthEntity toEntity({AuthEntity? batch}) {
    return AuthEntity(
      authId: authId,
      username: username,
      email: email,
      password: password,
      confirmPassword:confirmPassword
    );
  }

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId:entity. authId,
      username:entity. username,
      email: entity.email,
      password: entity.password,
      confirmPassword:entity.confirmPassword
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
