import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/project.dart';
import '../domain/project_repository.dart';

// Inject only after Firebase initialization AND authentication are implemented.
class FirebaseProjectRepository implements ProjectRepository {
  FirebaseProjectRepository({
    required this.firestore,
    required this.functions,
    required this.uid,
  });
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final String uid;
  @override
  Stream<List<Project>> watchProjects() => firestore
      .collection('users')
      .doc(uid)
      .collection('projectRefs')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Project(id: doc.id, name: doc.data()['name'] as String),
            )
            .toList(),
      );
  @override
  Future<void> createProject(String name, {required String requestId}) async {
    try {
      await functions.httpsCallable('createProject').call<void>({
        'name': name,
        'requestId': requestId,
      });
    } on FirebaseFunctionsException catch (error) {
      throw AppException(error.message ?? 'Proje kaydedilemedi.');
    }
  }
}
