import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String role;
  final String createdAt;
  final String updatedAt;

  const AdminUserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, username, role, createdAt, updatedAt];
}
