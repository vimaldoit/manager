import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_event.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_state.dart';
import 'package:taskmanager/features/task/presentation/widgets/kanban_column.dart';
import 'package:taskmanager/features/task/presentation/widgets/task_dialog.dart';

class KanbanScreen extends StatefulWidget {
  final String projectId;

  const KanbanScreen({super.key, required this.projectId});

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksEvent(widget.projectId));
  }

  void _showTaskDialog([TaskEntity? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (contextt) => TaskDialog(
        projectId: widget.projectId,
        task: task,
        onSave: (updatedTask) {
          if (task == null) {
            context.read<TaskBloc>().add(CreateTaskEvent(updatedTask));
          } else {
            context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
          }
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanban Board"),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success),
            );
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksLoaded) {
            final todoTasks =
                state.tasks.where((t) => t.status == TaskStatus.todo).toList();
            final inProgressTasks = state.tasks
                .where((t) => t.status == TaskStatus.inProgress)
                .toList();
            final doneTasks =
                state.tasks.where((t) => t.status == TaskStatus.done).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KanbanColumn(
                    title: "To Do",
                    status: TaskStatus.todo,
                    tasks: todoTasks,
                    onTaskDropped: (task, newStatus) {
                      context.read<TaskBloc>().add(UpdateTaskStatusEvent(
                            task: task,
                            newStatus: newStatus,
                          ));
                    },
                    onTaskDeleted: (task) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(
                            taskId: task.id,
                            projectId: widget.projectId,
                          ));
                    },
                    onTaskEdited: _showTaskDialog,
                  ),
                  KanbanColumn(
                    title: "In Progress",
                    status: TaskStatus.inProgress,
                    tasks: inProgressTasks,
                    onTaskDropped: (task, newStatus) {
                      context.read<TaskBloc>().add(UpdateTaskStatusEvent(
                            task: task,
                            newStatus: newStatus,
                          ));
                    },
                    onTaskDeleted: (task) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(
                            taskId: task.id,
                            projectId: widget.projectId,
                          ));
                    },
                    onTaskEdited: _showTaskDialog,
                  ),
                  KanbanColumn(
                    title: "Done",
                    status: TaskStatus.done,
                    tasks: doneTasks,
                    onTaskDropped: (task, newStatus) {
                      context.read<TaskBloc>().add(UpdateTaskStatusEvent(
                            task: task,
                            newStatus: newStatus,
                          ));
                    },
                    onTaskDeleted: (task) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(
                            taskId: task.id,
                            projectId: widget.projectId,
                          ));
                    },
                    onTaskEdited: _showTaskDialog,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
