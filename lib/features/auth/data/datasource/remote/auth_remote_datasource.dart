import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/core/services/storage/user_session.dart';
import 'package:tiffinmate/features/auth/data/datasource/auth_datasource.dart';
import 'package:tiffinmate/features/auth/data/models/auth_api_model.dart';



//create provider 
final authRemoteDataSourceProvider = Provider <IAuthRemoteDataSource>((ref){
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionServices:ref.read(userSessionServiceProvider),
  );
});



class AuthRemoteDatasource implements IAuthRemoteDataSource{

  final ApiClient _apiClient;
  final UserSessionServices _userSessionServices;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

   AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionServices userSessionServices,
  })  : _apiClient = apiClient,
        _userSessionServices = userSessionServices;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async{
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data:{'email':email,'password':password});

      if(response.data['success']==true){
      final raw = response.data as Map<String, dynamic>;
      final data= raw['data'] as Map<String,dynamic>;

      // Try to extract JWT token from common fields
      String? token;
      if (raw['accessToken'] is String) {
        token = raw['accessToken'] as String;
      } else if (raw['token'] is String) {
        token = raw['token'] as String;
      } else if (data['accessToken'] is String) {
        token = data['accessToken'] as String;
      } else if (data['token'] is String) {
        token = data['token'] as String;
      }

      if (token != null && token.isNotEmpty) {
        await _secureStorage.write(key: _tokenKey, value: token);
      }

      final user= AuthApiModel.fromJson(data);

      // save to session
      await _userSessionServices.saveUserSession(
        userId: user.id!, 
        email: email,  
        username: user.username,
        role: user.role,
        );
      return user;
    }
    return null;
  }
  
  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response= await _apiClient.post(
      ApiEndpoints.register,
      data:user.toJson(),
    );
    if(response.data['success']==true){
      final data= response.data['data'] as Map<String,dynamic>;
      final registeredUser= AuthApiModel.fromJson(data);
      return registeredUser;
    }
    return user;
  }
}