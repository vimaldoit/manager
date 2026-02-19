import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.done:
        return AppColors.success;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case TaskStatus.todo:
        return "To Do";
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.done:
        return "Done";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        child: ListTile(
          leading: Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            task.title,
            style: AppTheme.bodyText2.copyWith(
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  style: AppTheme.bodyText3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              SizedBox(height: 4.h),
              Text(
                _getStatusText(),
                style: AppTheme.bodyText3.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primary, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
