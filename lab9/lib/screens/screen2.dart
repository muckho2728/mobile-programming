import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final StorageService storage = StorageService();
  final TextEditingController controller = TextEditingController();
  List items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await storage.readData();
    setState(() {});
  }

  void addItem() {
    items.add({
      "id": DateTime.now().millisecondsSinceEpoch,
      "name": controller.text
    });
    controller.clear();
    setState(() {});
  }

  void save() async {
    await storage.writeData(items);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 9.2 - Save JSON")),
      body: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(onPressed: addItem, child: const Text("Add")),
          ElevatedButton(onPressed: save, child: const Text("Save")),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(items[i]['name']),
              ),
            ),
          )
        ],
      ),
    );
  }
}