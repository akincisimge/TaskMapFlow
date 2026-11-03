import 'dart:async';

import '../../../core/errors/app_exception.dart';
import '../domain/project.dart';
import '../domain/project_repository.dart';

class DemoProjectRepository implements ProjectRepository {
  final _changes = StreamController<List<Project>>.broadcast();
  final _projects = <Project>[const Project(id: 'demo', name: 'Konsept Dersi')];
  int _nextId = 0;
  @override
  Stream<List<Project>> watchProjects() async* {
    yield List.unmodifiable(_projects);
    yield* _changes.stream;
  }

  @override
  Future<void> createProject(String name, {required String requestId}) async {
    if (name.trim().isEmpty || name.trim().length > 100) {
      throw const AppException('Proje adı 1-100 karakter olmalı.');
    }
    _projects.add(Project(id: 'local-${++_nextId}', name: name.trim()));
    _changes.add(List.unmodifiable(_projects));
  }

  Future<void> dispose() => _changes.close();
}
