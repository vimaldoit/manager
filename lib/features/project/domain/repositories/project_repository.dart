import 'package:taskmanager/features/project/domain/entities/project_entity.dart';

abstract class ProjectRepository {
  Future<void> createProject(ProjectEntity project);
  Future<List<ProjectEntity>> getProjects();
  Future<ProjectEntity> getProjectById(String id);
  Future<void> updateProject(ProjectEntity project);
  Future<void> deleteProject(String id);
}
