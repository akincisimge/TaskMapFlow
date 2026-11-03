import '../../../core/errors/app_exception.dart';

class DependencyEdge {
  const DependencyEdge(this.predecessorId, this.successorId);
  final String predecessorId;
  final String successorId;
}

class DependencyGraph {
  DependencyGraph(Iterable<DependencyEdge> edges) : _edges = List.of(edges);
  final List<DependencyEdge> _edges;
  List<DependencyEdge> get edges => List.unmodifiable(_edges);
  void add(String predecessor, String successor) {
    if (predecessor == successor || _reachable(successor, predecessor)) {
      throw const AppException('Bağımlılık döngü oluşturamaz.');
    }
    if (!_edges.any(
      (e) => e.predecessorId == predecessor && e.successorId == successor,
    )) {
      _edges.add(DependencyEdge(predecessor, successor));
    }
  }

  bool _reachable(String start, String target) {
    final stack = [start];
    final visited = <String>{};
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (node == target) return true;
      if (!visited.add(node)) continue;
      stack.addAll(
        _edges.where((e) => e.predecessorId == node).map((e) => e.successorId),
      );
    }
    return false;
  }
}
