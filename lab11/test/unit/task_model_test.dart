import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Default completed is false', () {
      final task = Task(title: "Test");
      expect(task.completed, false);
    });

    test('toggle switches state', () {
      final task = Task(title: "Test");
      task.toggle();
      expect(task.completed, true);
    });
  });
}