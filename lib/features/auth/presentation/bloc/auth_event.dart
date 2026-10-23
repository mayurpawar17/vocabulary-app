import 'package:equatable/equatable.dart';
import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged(this.user);

  final AuthUser? user;

  @override
  List<Object?> get props => [user?.id];
}

class SignInRequested extends AuthEvent {
  const SignInRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegistrationRequested extends AuthEvent {
  const RegistrationRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
