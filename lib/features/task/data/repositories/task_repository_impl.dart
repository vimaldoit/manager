import 'package:taskmanager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskmanager/features/task/data/models/task_model.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTask(TaskEntity task) {
    return remoteDataSource.createTask(TaskModel.fromEntity(task));
  }

  @override
  Future<List<TaskEntity>> getTasks(String projectId) async {
    return await remoteDataSource.getTasks(projectId);
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return remoteDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) {
    return remoteDataSource.deleteTask(id);
  }
}
