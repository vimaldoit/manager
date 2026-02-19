import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskEntity>> call(String projectId) {
    return repository.getTasks(projectId);
  }
}
