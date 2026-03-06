import 'package:equatable/equatable.dart';


class AuthEntity extends Equatable {
  final String? authId;
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String role;


  const AuthEntity({
    this.authId,
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [
    authId,
    username,
    email,
    confirmPassword,
    password,
    role,
  ];
}
