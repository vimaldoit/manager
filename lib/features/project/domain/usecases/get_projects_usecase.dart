import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<List<ProjectEntity>> call() {
    return repository.getProjects();
  }
}
