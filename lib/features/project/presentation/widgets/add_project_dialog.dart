import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/common%20_widgets/common_button.dart';
import 'package:taskmanager/core/common%20_widgets/textfield_widget.dart';
import 'package:taskmanager/core/common%20_widgets/vspace.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/core/utils/validator.dart';
import 'package:taskmanager/features/project/domain/entities/project_entity.dart';
import 'package:uuid/uuid.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(ProjectEntity) onAdd;

  const AddProjectDialog({super.key, required this.onAdd});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              "Create New Project",
              style: AppTheme.bodyText2.copyWith(fontSize: 20.sp),
            ),
            const Vspace(24),
            CommonTextFormField(
              controller: _nameController,
              hintColor: AppColors.textSecondary,
              hintText: "Project Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a project name";
                }
                return null;
              },
            ),
            const Vspace(16),
            CommonTextFormField(
              hintColor: AppColors.textSecondary,
              controller: _descriptionController,
              hintText: "Description",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a description";
                }
                return null;
              },
            ),
            const Vspace(24),
            CommonButton(
              text: "Create Project",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final project = ProjectEntity(
                    id: const Uuid().v4(),
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  widget.onAdd(project);
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
