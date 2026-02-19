import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/features/task/domain/usecases/create_task_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/get_tasks_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/update_task_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onGetTasks(GetTasksEvent event, Emitter<TaskState> emit) async {
    if (event.showLoading) {
      emit(TaskLoading());
    }
    try {
      final tasks = await getTasksUseCase(event.projectId);
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase(event.task);
      emit(const TaskOperationSuccess("Task created successfully"));
      add(GetTasksEvent(event.task.projectId, showLoading: false));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTaskUseCase(event.task);
      add(GetTasksEvent(event.task.projectId, showLoading: false));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await deleteTaskUseCase(event.taskId);
      emit(const TaskOperationSuccess("Task deleted successfully"));
      add(GetTasksEvent(event.projectId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatusEvent event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = event.task.copyWith(status: event.newStatus);
      await updateTaskUseCase(updatedTask);
      add(GetTasksEvent(event.task.projectId, showLoading: false));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
