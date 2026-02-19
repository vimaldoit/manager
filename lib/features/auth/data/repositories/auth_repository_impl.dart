import 'package:taskmanager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskmanager/features/auth/data/models/user_model.dart';
import 'package:taskmanager/features/auth/domain/entities/user_entity.dart';
import 'package:taskmanager/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final credential = await remoteDataSource.signIn(email, password);
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    final credential = await remoteDataSource.signUp(email, password);
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Stream<UserEntity?> get user => remoteDataSource.userStream.map((user) {
        return user != null ? UserModel.fromFirebaseUser(user) : null;
      });

  @override
  UserEntity? get currentUser {
    final user = remoteDataSource.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
