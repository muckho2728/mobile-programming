import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Full flow test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TaskListScreen()),
    );

    await tester.enterText(find.byType(TextField).first, "Original");
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.tap(find.text("Original"));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key("detailTitleField")), "Updated");

    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    expect(find.text("Updated"), findsOneWidget);
  });
}