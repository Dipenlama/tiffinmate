import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';

class PaginatedAdminUsersEntity extends Equatable {
  final List<AdminUserEntity> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedAdminUsersEntity({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [users, total, page, limit, totalPages];
}
