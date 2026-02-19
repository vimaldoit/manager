part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<ProjectEntity> projects;
  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectLoaded extends ProjectState {
  final ProjectEntity project;
  const ProjectLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectOperationSuccess extends ProjectState {
  final String message;
  const ProjectOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
