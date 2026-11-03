import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/dependency_graph.dart';
import '../../tasks/domain/task.dart';

class DependencyMap extends StatelessWidget {
  const DependencyMap({super.key, required this.tasks, required this.edges});
  final List<Task> tasks;
  final List<DependencyEdge> edges;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Ok yönü: ön koşul → bekleyen görev. Demo ilişkileri örnek olarak tanımlıdır.',
      ),
      const SizedBox(height: 12),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              height: math.max(180, tasks.length * 145).toDouble(),
              child: CustomPaint(
                painter: _EdgePainter(tasks, edges),
                child: Stack(
                  children: [
                    for (var i = 0; i < tasks.length; i++)
                      Positioned(
                        left: 16,
                        top: i * 145.0,
                        width: 300,
                        height: 100,
                        child: Semantics(
                          label: '${tasks[i].title}, ${tasks[i].status.name}',
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tasks[i].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(switch (tasks[i].status) {
                                    TaskStatus.todo => 'Yapılacak',
                                    TaskStatus.inProgress => 'Devam ediyor',
                                    TaskStatus.done => 'Tamamlandı',
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      if (edges.isNotEmpty)
        Text(
          'İlişkiler: ${edges.map((e) => '${tasks.firstWhere((t) => t.id == e.predecessorId).title} → ${tasks.firstWhere((t) => t.id == e.successorId).title}').join('; ')}',
        ),
    ],
  );
}

class _EdgePainter extends CustomPainter {
  _EdgePainter(this.tasks, this.edges);
  final List<Task> tasks;
  final List<DependencyEdge> edges;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3151B7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final edge in edges) {
      final a = tasks.indexWhere((t) => t.id == edge.predecessorId);
      final b = tasks.indexWhere((t) => t.id == edge.successorId);
      if (a < 0 || b < 0) continue;
      final start = Offset(166, a * 145.0 + 100);
      final end = Offset(166, b * 145.0);
      final lane = 333.0 + (a % 3) * 8;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx, start.dy + 12)
        ..lineTo(lane, start.dy + 12)
        ..lineTo(lane, end.dy - 12)
        ..lineTo(end.dx, end.dy - 12)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);
      canvas.drawLine(end, end + const Offset(-5, -7), paint);
      canvas.drawLine(end, end + const Offset(5, -7), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) =>
      oldDelegate.tasks != tasks || oldDelegate.edges != edges;
}
