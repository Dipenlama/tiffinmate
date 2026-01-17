import 'package:equatable/equatable.dart';


class AuthEntity extends Equatable {
  final String? authId;
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;


  const AuthEntity({
    this.authId,
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword
  });

  @override
  List<Object?> get props => [
    authId,
    username,
    email,
    confirmPassword,
    password,
  ];
}
