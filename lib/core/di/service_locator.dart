import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:taskmanager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskmanager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskmanager/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskmanager/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:taskmanager/features/auth/domain/usecases/login_usecase.dart';
import 'package:taskmanager/features/auth/domain/usecases/signup_usecase.dart';
import 'package:taskmanager/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:taskmanager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskmanager/features/project/data/datasources/project_remote_data_source.dart';
import 'package:taskmanager/features/project/data/repositories/project_repository_impl.dart';
import 'package:taskmanager/features/project/domain/repositories/project_repository.dart';
import 'package:taskmanager/features/project/domain/usecases/create_project_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/get_project_by_id_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:taskmanager/features/project/domain/usecases/update_project_usecase.dart';
import 'package:taskmanager/features/project/presentation/bloc/project_bloc.dart';
import 'package:taskmanager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskmanager/features/task/data/repositories/task_repository_impl.dart';
import 'package:taskmanager/features/task/domain/repositories/task_repository.dart';
import 'package:taskmanager/features/task/domain/usecases/create_task_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/get_tasks_usecase.dart';
import 'package:taskmanager/features/task/domain/usecases/update_task_usecase.dart';
import 'package:taskmanager/features/task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      isUserLoggedInUseCase: sl(),
    ),
  );

  // Features - Project
  sl.registerFactory(
    () => ProjectBloc(
      createProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
      getProjectByIdUseCase: sl(),
      getProjectsUseCase: sl(),
      updateProjectUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => TaskBloc(
      getTasksUseCase: sl(),
      createTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => IsUserLoggedInUseCase(sl()));

  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));

  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
