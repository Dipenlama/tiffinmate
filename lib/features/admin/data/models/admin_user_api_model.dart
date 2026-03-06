import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';

class AdminUserApiModel {
  final String id;
  final String email;
  final String username;
  final String role;
  final String createdAt;
  final String updatedAt;

  AdminUserApiModel({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUserApiModel.fromJson(Map<String, dynamic> json) {
    return AdminUserApiModel(
      id: (json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      role: (json['role'] ?? 'user').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
    );
  }

  AdminUserEntity toEntity() {
    return AdminUserEntity(
      id: id,
      email: email,
      username: username,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<AdminUserEntity> toEntityList(List<dynamic> list) {
    return list
        .map((e) => AdminUserApiModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }
}
