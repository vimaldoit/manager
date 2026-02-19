part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class GetProjectsEvent extends ProjectEvent {}

class GetProjectByIdEvent extends ProjectEvent {
  final String id;
  const GetProjectByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProjectEvent extends ProjectEvent {
  final ProjectEntity project;
  const CreateProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class UpdateProjectEvent extends ProjectEvent {
  final ProjectEntity project;
  const UpdateProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProjectEvent extends ProjectEvent {
  final String id;
  const DeleteProjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}
