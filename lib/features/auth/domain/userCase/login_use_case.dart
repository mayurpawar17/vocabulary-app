import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<AuthUser> execute(LoginRequest loginRequest) {
    return _authRepository.login(loginRequest);
  }
}