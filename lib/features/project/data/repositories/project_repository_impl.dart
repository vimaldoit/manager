import 'package:taskmanager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:taskmanager/features/project/data/models/project_model.dart';
import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createProject(ProjectEntity project) {
    return remoteDataSource.createProject(ProjectModel.fromEntity(project));
  }

  @override
  Future<List<ProjectEntity>> getProjects() async {
    return await remoteDataSource.getProjects();
  }

  @override
  Future<ProjectEntity> getProjectById(String id) async {
    return await remoteDataSource.getProjectById(id);
  }

  @override
  Future<void> updateProject(ProjectEntity project) {
    return remoteDataSource.updateProject(ProjectModel.fromEntity(project));
  }

  @override
  Future<void> deleteProject(String id) {
    return remoteDataSource.deleteProject(id);
  }
}
