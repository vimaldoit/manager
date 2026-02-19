import 'package:taskmanager/features/auth/domain/entities/user_entity.dart';
import 'package:taskmanager/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.signUp(email, password);
  }
}
