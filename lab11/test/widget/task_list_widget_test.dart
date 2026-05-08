import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Empty state shown', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TaskListScreen()),
    );

    expect(find.text("No tasks yet. Add one!"), findsOneWidget);
  });

  testWidgets('Add task updates UI', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TaskListScreen()),
    );

    await tester.enterText(find.byType(TextField).first, "Test Task");
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text("Test Task"), findsOneWidget);
  });
}