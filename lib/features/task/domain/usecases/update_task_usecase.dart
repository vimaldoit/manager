import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) {
    return repository.updateTask(task);
  }
}
