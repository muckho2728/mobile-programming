import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository? repository;

  const TaskListScreen({super.key, this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TaskRepository repository;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    repository = widget.repository ?? TaskRepository();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = repository.getTasks();

    return Scaffold(
      appBar: AppBar(title: const Text("Taskly")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: controller),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        repository.addTask(
                          Task(title: controller.text),
                        );
                        controller.clear();
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text("No tasks yet. Add one!"),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(
                          task: tasks[index],
                          onSave: (newTitle) {
                            setState(() {
                              repository.updateTask(
                                index,
                                Task(title: newTitle),
                              );
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}