import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List products = [];

  Future<void> loadJson() async {
    String data = await rootBundle.loadString('assets/data/products.json');
    final decoded = jsonDecode(data);
    setState(() {
      products = decoded;
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 9.1 - Read JSON")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text("Price: \$${item['price']}"),
          );
        },
      ),
    );
  }
}