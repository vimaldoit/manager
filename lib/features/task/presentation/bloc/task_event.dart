import 'package:equatable/equatable.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final String projectId;
  final bool showLoading;
  const GetTasksEvent(this.projectId, {this.showLoading = true});

  @override
  List<Object?> get props => [projectId, showLoading];
}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String projectId;
  const DeleteTaskEvent({required this.taskId, required this.projectId});

  @override
  List<Object?> get props => [taskId, projectId];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final TaskEntity task;
  final TaskStatus newStatus;

  const UpdateTaskStatusEvent({required this.task, required this.newStatus});

  @override
  List<Object?> get props => [task, newStatus];
}
