import 'package:tiffinmate/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;

  AuthApiModel({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword,
  });

  //toJson
  Map<String,dynamic> toJson(){
    return{
      "username":username,
      "email":email,
      "password":password,
      "confirmPassword":confirmPassword,
    };
  }


  //fromJson
  factory AuthApiModel.fromJson(Map<String,dynamic>json){
    return AuthApiModel(
      id:json['_id'] as String,
      username: json['username'] as String,
      email: json ['email'] as String,
      );
  }

  //toEntity
  AuthEntity toEntity(){
    return AuthEntity(
      authId: id,
      username:username,
      email: email,
    );
  }


  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity){
    return AuthApiModel(
      username:entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  //toENtityList
  static List<AuthEntity> toENtityList(List<AuthApiModel> models){
    return models.map((model)=>model.toEntity()).toList();
  }

}

