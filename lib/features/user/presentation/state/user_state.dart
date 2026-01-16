import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/user/domain/entities/user_entity.dart';

enum BatchStatus { initial, loading, loaded, error, created, updated, deleted }

class BatchState extends Equatable {
  final BatchStatus status;
  final List<UserEntity> batches;
  final String? errorMessage;

  const BatchState({
    this.status = UserStatus.initial,
    this.batches = const [],
    this.errorMessage,
  });

  BatchState copyWith({
    BatchStatus? status,
    List<UserEntityq>? batches,
    String? errorMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, batches, errorMessage];
}