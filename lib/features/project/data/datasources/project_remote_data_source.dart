import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager/features/project/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<void> createProject(ProjectModel project);
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath = 'projects';

  ProjectRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createProject(ProjectModel project) async {
    await firestore.collection(collectionPath).doc(project.id).set(project.toJson());
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) => ProjectModel.fromJson(doc.data())).toList();
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final doc = await firestore.collection(collectionPath).doc(id).get();
    if (doc.exists) {
      return ProjectModel.fromJson(doc.data()!);
    } else {
      throw Exception('Project not found');
    }
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    await firestore.collection(collectionPath).doc(project.id).update(project.toJson());
  }

  @override
  Future<void> deleteProject(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }
}
