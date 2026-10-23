import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';

abstract class AuthRepository {
  Future<UserCredential> login(LoginRequest loginRequest);
  Future<UserCredential> register(RegisterRequest registerRequest);
  Future<void> logout();
}