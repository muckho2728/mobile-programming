import 'package:flutter/material.dart';
import '../models/task.dart';

// Ex 12.1: Widget tách riêng, chỉ rebuild khi task của nó thay đổi
class TaskTile extends StatelessWidget {
  final Task task;
  final bool isSelected;
  final VoidCallback onToggle;

  const TaskTile({
    Key? key,
    required this.task,
    required this.isSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      leading: Checkbox(
        value: isSelected,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          color: task.isDone ? Colors.grey : null,
        ),
      ),
      subtitle: task.isDone
          ? const Text('Completed', style: TextStyle(color: Colors.green, fontSize: 12))
          : null,
    );
  }
}