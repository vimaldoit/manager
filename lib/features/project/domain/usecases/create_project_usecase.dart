import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  Future<void> call(ProjectEntity project) {
    return repository.createProject(project);
  }
}
