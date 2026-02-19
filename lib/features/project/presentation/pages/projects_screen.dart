import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/features/project/presentation/bloc/project_bloc.dart';
import 'package:taskmanager/features/project/presentation/widgets/project_card.dart';
import 'package:taskmanager/features/project/presentation/widgets/add_project_dialog.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(GetProjectsEvent());
  }

  void _showAddProjectDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (contextt) => AddProjectDialog(
        onAdd: (project) {
          context.read<ProjectBloc>().add(CreateProjectEvent(project));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProjectBloc>().add(GetProjectsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is ProjectOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success),
            );
          } else if (state is ProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectsLoaded) {
            if (state.projects.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open,
                        size: 64.sp, color: AppColors.textSecondary),
                    SizedBox(height: 16.h),
                    Text(
                      "No projects yet",
                      style: AppTheme.bodyText2
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Tap + to create your first project",
                      style: AppTheme.bodyText3
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.projects.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () {
                    // Navigate to project details/tasks
                  },
                  onDelete: () {
                    context
                        .read<ProjectBloc>()
                        .add(DeleteProjectEvent(project.id));
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
