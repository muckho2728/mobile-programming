import 'dart:async';

import 'models/product.dart';
import 'models/settings.dart';
import 'repositories/product_repository.dart';
import 'repositories/user_repository.dart';

Future<void> main() async {
  print('===== PRODUCT REPOSITORY =====');
  final productRepo = ProductRepository();
  productRepo.liveAdded().listen((product) {
    print('Live stream received: $product');
  });
  productRepo.addProduct(Product(1, 'Laptop', 1200));
  productRepo.addProduct(Product(2, 'Mouse', 25));
  final products = await productRepo.getAll();
  products.forEach(print);
  print('\n===== USER JSON REPOSITORY =====');
  final userRepo = UserRepository();
  final users = await userRepo.fetchUsers();
  users.forEach(print);
  print('\n===== ASYNC vs MICROTASK =====');
  print('Start');
  scheduleMicrotask(() {
    print('Microtask executed');
  });
  Future(() {
    print('Future event executed');
  });
  print('End');
  await Future.delayed(Duration(seconds: 1));
  print('\n===== STREAM TRANSFORMATION =====');
  Stream<int> stream = Stream.fromIterable([1, 2, 3, 4, 5])
      .map((n) => n * n)
      .where((squared) => squared % 2 == 0);

  await for (var value in stream) {
    print('Emitted: $value');
  };
  print('\n===== FACTORY & SINGLETON =====');
  final a = Settings();
  final b = Settings();
  print('Same instance: ${identical(a, b)}');
}