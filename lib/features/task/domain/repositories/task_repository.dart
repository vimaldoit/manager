import 'package:taskmanager/features/task/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(TaskEntity task);
  Future<List<TaskEntity>> getTasks(String projectId);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
}
