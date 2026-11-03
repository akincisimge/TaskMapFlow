import 'package:flutter_test/flutter_test.dart';
import 'package:taskmapflow/features/dependencies/domain/dependency_graph.dart';
import 'package:taskmapflow/features/tasks/data/demo_task_repository.dart';
import 'package:taskmapflow/features/tasks/domain/task.dart';

void main() {
  test(
    'rejects direct and transitive dependency cycles; deduplicates edges',
    () {
      final graph = DependencyGraph([])
        ..add('a', 'b')
        ..add('b', 'c');
      expect(() => graph.add('c', 'a'), throwsException);
      expect(() => graph.add('a', 'a'), throwsException);
      graph.add('a', 'b');
      expect(graph.edges, hasLength(2));
    },
  );
  test('preconditions and reopen policy preserve task consistency', () {
    final repo = DemoTaskRepository();
    expect(
      () => repo.changeStatus('demo', 'implement', TaskStatus.inProgress),
      throwsException,
    );
    expect(
      () => repo.changeStatus('demo', 'vision', TaskStatus.todo),
      throwsException,
    );
    repo.changeStatus('demo', 'design', TaskStatus.done);
    repo.changeStatus('demo', 'implement', TaskStatus.inProgress);
    expect(repo.tasksFor('demo').last.status, TaskStatus.inProgress);
  });
  test('new project tasks remain isolated and empty names are rejected', () {
    final repo = DemoTaskRepository();
    repo.createTask('another', 'Yeni görev');
    expect(repo.tasksFor('another'), hasLength(1));
    expect(repo.tasksFor('demo'), hasLength(3));
    expect(() => repo.createTask('demo', '   '), throwsException);
  });
}
