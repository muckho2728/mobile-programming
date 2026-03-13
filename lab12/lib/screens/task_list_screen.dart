import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

//Ex 12.1: StatefulWidget để quản lý selectedIds + precacheImage
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  //Danh sách id các task đang được chọn để xóa
  final Set<String> _selectedIds = {};

  //Ex 12.2: Precache logo khi màn hình khởi động
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/logo.png'), context);
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _deleteSelected(BuildContext context) {
    context.read<TaskProvider>().deleteSelectedTasks(_selectedIds.toList());
    setState(() => _selectedIds.clear());
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter task title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TaskProvider>().addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png', width: 32, height: 32),
        ),
        title: Text(
          //Hiện số lượng đang chọn trên AppBar
          hasSelection ? '${_selectedIds.length} selected' : 'Lab12-VuTienDat',
        ),
        actions: [
          if (hasSelection) ...[
            //Nút xóa chỉ xuất hiện khi có task được chọn
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete selected',
              color: Colors.red,
              onPressed: () => _showDeleteConfirm(context),
            ),
            //Nút bỏ chọn tất cả
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Clear selection',
              onPressed: () => setState(() => _selectedIds.clear()),
            ),
          ],
        ],
      ),
      //Ex 12.1: Selector chỉ rebuild khi List<Task> thay đổi
      body: Selector<TaskProvider, List<Task>>(
        selector: (_, provider) => provider.tasks,
        builder: (context, tasks, _) {
          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tasks yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Tap + to add a new task',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                key: ValueKey(task.id), // ✅ Ex 12.1: ValueKey
                task: task,
                isSelected: _selectedIds.contains(task.id),
                onToggle: () => _toggleSelect(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete tasks'),
        content: Text(
          'Delete ${_selectedIds.length} selected task(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSelected(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}