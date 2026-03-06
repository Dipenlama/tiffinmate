import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/admin/data/models/admin_user_api_model.dart';

final adminUsersRemoteDataSourceProvider = Provider<IAdminUsersRemoteDataSource>((ref) {
  return AdminUsersRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

abstract class IAdminUsersRemoteDataSource {
  Future<Map<String, dynamic>> getUsers({int page, int limit});
  Future<AdminUserApiModel> getUser(String id);
  Future<AdminUserApiModel> createUser({
    required String email,
    required String username,
    required String password,
    String? confirmPassword,
  });
  Future<AdminUserApiModel> updateUser({
    required String id,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  });
  Future<void> deleteUser(String id);
}

class AdminUsersRemoteDataSource implements IAdminUsersRemoteDataSource {
  final ApiClient _apiClient;

  AdminUsersRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 10}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminUsers,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return (response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<AdminUserApiModel> getUser(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.adminUsers}/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return AdminUserApiModel.fromJson(data);
  }

  @override
  Future<AdminUserApiModel> createUser({
    required String email,
    required String username,
    required String password,
    String? confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminUsers,
      data: {
        'email': email,
        'username': username,
        'password': password,
        if (confirmPassword != null) 'confirmPassword': confirmPassword,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AdminUserApiModel.fromJson(data);
  }

  @override
  Future<AdminUserApiModel> updateUser({
    required String id,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  }) async {
    final Map<String, dynamic> body = {};
    if (email != null) body['email'] = email;
    if (username != null) body['username'] = username;
    if (password != null) body['password'] = password;
    if (confirmPassword != null) body['confirmPassword'] = confirmPassword;

    final response = await _apiClient.put(
      '${ApiEndpoints.adminUsers}/$id',
      data: body,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AdminUserApiModel.fromJson(data);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _apiClient.delete('${ApiEndpoints.adminUsers}/$id');
  }
}
