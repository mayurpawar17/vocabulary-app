import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<AuthUser> execute(RegisterRequest registerRequest) {
    return _authRepository.register(registerRequest);
  }
}