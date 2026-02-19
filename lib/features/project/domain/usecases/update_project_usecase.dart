import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase(this.repository);

  Future<void> call(ProjectEntity project) {
    return repository.updateProject(project);
  }
}
