import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';

enum AdminUsersListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class AdminUsersListState extends Equatable {
  final AdminUsersListStatus status;
  final List<AdminUserEntity> users;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const AdminUsersListState({
    this.status = AdminUsersListStatus.initial,
    this.users = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  AdminUsersListState copyWith({
    AdminUsersListStatus? status,
    List<AdminUserEntity>? users,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return AdminUsersListState(
      status: status ?? this.status,
      users: users ?? this.users,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, page, totalPages, errorMessage];
}
