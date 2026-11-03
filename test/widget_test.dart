import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmapflow/app/task_map_flow_app.dart';

void main() {
  testWidgets('opens project, shows dependency map and creates a local task', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskMapFlowApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('Yerel demo'), findsOneWidget);
    await tester.tap(find.text('Konsept Dersi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Harita'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ok yönü'), findsOneWidget);
    await tester.tap(find.text('Görevler'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Görev ekle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Yeni test görevi');
    await tester.tap(find.text('Ekle'));
    await tester.pumpAndSettle();
    expect(find.text('Yeni test görevi'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
