import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:taskmanager/features/task/presentation/widgets/task_item.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final Function(TaskEntity, TaskStatus) onTaskDropped;
  final Function(TaskEntity) onTaskDeleted;
  final Function(TaskEntity) onTaskEdited;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.status,
    required this.tasks,
    required this.onTaskDropped,
    required this.onTaskDeleted,
    required this.onTaskEdited,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskEntity>(
      onAccept: (task) {
        if (task.status != status) {
          onTaskDropped(task, status);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 300.w,
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty 
                ? AppColors.primary.withOpacity(0.1) 
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: candidateData.isNotEmpty 
                  ? AppColors.primary 
                  : AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyText2.copyWith(fontSize: 18.sp),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.listBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tasks.length.toString(),
                        style: AppTheme.bodyText3.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return LongPressDraggable<TaskEntity>(
                      data: task,
                      feedback: SizedBox(
                        width: 280.w,
                        child: Material(
                          color: Colors.transparent,
                          child: TaskItem(
                            task: task,
                            onDelete: () {},
                            onEdit: () {},
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: TaskItem(
                          task: task,
                          onDelete: () {},
                          onEdit: () {},
                        ),
                      ),
                      child: TaskItem(
                        task: task,
                        onDelete: () => onTaskDeleted(task),
                        onEdit: () => onTaskEdited(task),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
