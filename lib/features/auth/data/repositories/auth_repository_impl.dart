import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_app/features/auth/data/remoteDataSource/auth_remote_data_source.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource2 _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<UserCredential> login(LoginRequest loginRequest) {
    return _authRemoteDataSource.login(loginRequest);
  }

  @override
  Future<UserCredential> register(RegisterRequest registerRequest) {
    return _authRemoteDataSource.register(registerRequest);
  }
@override
  Future<void> logout() {
    return _authRemoteDataSource.logout();
  }
}