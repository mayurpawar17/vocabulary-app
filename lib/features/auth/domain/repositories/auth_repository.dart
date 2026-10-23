import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> login(LoginRequest loginRequest);
  Future<AuthUser> register(RegisterRequest registerRequest);
  Future<void> logout();
}