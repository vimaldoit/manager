import 'package:taskmanager/features/auth/domain/repositories/auth_repository.dart';

class IsUserLoggedInUseCase {
  final AuthRepository repository;

  IsUserLoggedInUseCase(this.repository);

  bool call() {
    return repository.currentUser != null;
  }
}
