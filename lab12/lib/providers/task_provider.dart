import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    ));
    notifyListeners();
  }

  // ✅ Toggle done/undone — tạo Task mới để Selector nhận ra thay đổi
  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = Task(
        id: _tasks[index].id,
        title: _tasks[index].title,
        isDone: !_tasks[index].isDone,
      );
      notifyListeners();
    }
  }

  // ✅ Xóa nhiều task theo danh sách id
  void deleteSelectedTasks(List<String> ids) {
    _tasks.removeWhere((t) => ids.contains(t.id));
    notifyListeners();
  }
}