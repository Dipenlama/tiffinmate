import 'package:tiffinmate/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String role;

  AuthApiModel({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword,
    this.role = 'user',
  });

  //toJson
  // Map<String,dynamic> toJson(){
  //   return{
  //     "username":username,
  //     "email":email,
  //     "password":password,
  //     "confirmPassword":confirmPassword,
  //   };
  // }
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword ?? "",
    };
  }



  //fromJson
  factory AuthApiModel.fromJson(Map<String,dynamic>json){
    return AuthApiModel(
      id: json['_id']?.toString(),
      username: json['username'] as String,
      email: json ['email'] as String,
      role: (json['role'] ?? 'user').toString(),
      );
  }

  //toEntity
  AuthEntity toEntity(){
    return AuthEntity(
      authId: id,
      username:username,
      email: email,
      role: role,
    );
  }


  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity){
    return AuthApiModel(
      username:entity.username,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      role: entity.role,
    );
  }

  //toENtityList
  static List<AuthEntity> toENtityList(List<AuthApiModel> models){
    return models.map((model)=>model.toEntity()).toList();
  }

}

