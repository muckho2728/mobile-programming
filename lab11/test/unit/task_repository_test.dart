import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('Repository Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask works', () {
      repository.addTask(Task(title: "New"));
      expect(repository.getTasks().length, 1);
    });

    test('deleteTask works', () {
      final task = Task(title: "New");
      repository.addTask(task);
      repository.deleteTask(task);
      expect(repository.getTasks().isEmpty, true);
    });

    test('updateTask works', () {
      repository.addTask(Task(title: "Old"));
      repository.updateTask(0, Task(title: "Updated"));
      expect(repository.getTasks()[0].title, "Updated");
    });
  });
}