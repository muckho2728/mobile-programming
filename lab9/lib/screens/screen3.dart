import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final StorageService storage = StorageService();
  List items = [];
  List filtered = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    items = await storage.readData();
    filtered = items;
    setState(() {});
  }

  void autoSave() async {
    await storage.writeData(items);
  }

  void addItem(String name) {
    items.add({
      "id": DateTime.now().millisecondsSinceEpoch,
      "name": name
    });
    autoSave();
    load();
  }

  void deleteItem(int index) {
    items.removeAt(index);
    autoSave();
    load();
  }

  void search(String keyword) {
    filtered = items
        .where((e) =>
        e['name'].toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 9.3 - CRUD JSON")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem("New Item");
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: search,
            decoration: const InputDecoration(
              hintText: "Search...",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(filtered[i]['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(i),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}