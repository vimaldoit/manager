import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/common%20_widgets/common_button.dart';
import 'package:taskmanager/core/common%20_widgets/textfield_widget.dart';
import 'package:taskmanager/core/common%20_widgets/vspace.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/features/task/domain/entities/task_entity.dart';
import 'package:uuid/uuid.dart';

class TaskDialog extends StatefulWidget {
  final String projectId;
  final TaskEntity? task;
  final Function(TaskEntity) onSave;

  const TaskDialog({
    super.key,
    required this.projectId,
    required this.onSave,
    this.task,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Edit Task" : "Add New Task",
              style: AppTheme.bodyText2.copyWith(fontSize: 20.sp),
            ),
            const Vspace(24),
            CommonTextFormField(
              controller: _titleController,
              hintColor: AppColors.textSecondary,
              hintText: "Task Title",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a task title";
                }
                return null;
              },
            ),
            const Vspace(16),
            CommonTextFormField(
              controller: _descriptionController,
              hintColor: AppColors.textSecondary,
              hintText: "Description (Optional)",
            ),
            const Vspace(24),
            CommonButton(
              text: isEditing ? "Save Changes" : "Add Task",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final task = widget.task?.copyWith(
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                      ) ??
                      TaskEntity(
                        id: const Uuid().v4(),
                        projectId: widget.projectId,
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        status: TaskStatus.todo,
                        createdAt: DateTime.now(),
                      );
                  widget.onSave(task);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
