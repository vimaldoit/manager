// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskmanager/features/project/domain/entities/project_entity.dart';

import 'package:taskmanager/features/project/domain/usecases/create_project_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/get_project_by_id_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/update_project_usecase.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final CreateProjectUseCase createProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final GetProjectByIdUseCase getProjectByIdUseCase;
  final GetProjectsUseCase getProjectsUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  ProjectBloc({
    required this.createProjectUseCase,
    required this.deleteProjectUseCase,
    required this.getProjectByIdUseCase,
    required this.getProjectsUseCase,
    required this.updateProjectUseCase,
  }) : super(ProjectInitial()) {
    on<GetProjectsEvent>(_onGetProjects);
    on<GetProjectByIdEvent>(_onGetProjectById);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onGetProjects(
    GetProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final projects = await getProjectsUseCase();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onGetProjectById(
    GetProjectByIdEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final project = await getProjectByIdUseCase(event.id);
      emit(ProjectLoaded(project));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      await createProjectUseCase(event.project);
      emit(const ProjectOperationSuccess("Project created successfully"));
      add(GetProjectsEvent());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      await updateProjectUseCase(event.project);
      emit(const ProjectOperationSuccess("Project updated successfully"));
      add(GetProjectsEvent());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      await deleteProjectUseCase(event.id);
      emit(const ProjectOperationSuccess("Project deleted successfully"));
      add(GetProjectsEvent());
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}
