import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/router/app_router.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_event.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_state.dart';
import 'package:taskmanager/features/task/presentation/widgets/task_item.dart';
import 'package:taskmanager/features/task/presentation/widgets/task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  final String projectId;

  const TaskListScreen({super.key, required this.projectId});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
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

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksEvent(widget.projectId));
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
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            onPressed: () {
              AppRouter.pushKanban(context, widget.projectId);
            },
          ),
        ],
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
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist,
                        size: 64.sp, color: AppColors.textSecondary),
                    SizedBox(height: 16.h),
                    Text(
                      "No tasks for this project",
                      style: AppTheme.bodyText2
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Tap + to add your first task",
                      style: AppTheme.bodyText3
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.tasks.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: () async {
                    final confirmed = await _showDeleteConfirmation(
                      context,
                      "Delete Task",
                      "Are you sure you want to delete this task?",
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(
                            taskId: task.id,
                            projectId: widget.projectId,
                          ));
                    }
                  },
                  onEdit: () {
                    _showTaskDialog(task);
                  },
                );
              },
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
