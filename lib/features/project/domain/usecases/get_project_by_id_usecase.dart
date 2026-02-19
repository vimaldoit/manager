import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';

class GetProjectByIdUseCase {
  final ProjectRepository repository;

  GetProjectByIdUseCase(this.repository);

  Future<ProjectEntity> call(String id) {
    return repository.getProjectById(id);
  }
}
