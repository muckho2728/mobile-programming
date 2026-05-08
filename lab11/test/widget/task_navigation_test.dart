import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Navigate to detail screen', (tester) async {
    final repository = TaskRepository();
    repository.addTask(Task(title: "Seeded"));

    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(repository: repository),
      ),
    );

    await tester.tap(find.text("Seeded"));
    await tester.pumpAndSettle();

    expect(find.text("Task Detail"), findsOneWidget);
    expect(find.byKey(const Key("detailTitleField")), findsOneWidget);
  });
}