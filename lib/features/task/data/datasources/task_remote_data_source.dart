import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager/features/task/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> createTask(TaskModel task);
  Future<List<TaskModel>> getTasks(String projectId);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath = 'tasks';

  TaskRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createTask(TaskModel task) async {
    await firestore.collection(collectionPath).doc(task.id).set(task.toJson());
  }

  @override
  Future<List<TaskModel>> getTasks(String projectId) async {
    final snapshot = await firestore
        .collection(collectionPath)
        .where('projectId', isEqualTo: projectId)
        .get();
    return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await firestore.collection(collectionPath).doc(task.id).update(task.toJson());
  }

  @override
  Future<void> deleteTask(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
