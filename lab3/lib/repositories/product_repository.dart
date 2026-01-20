import 'dart:async';
import '../models/product.dart';

class ProductRepository {
  final List<Product> _products = [];
  final StreamController<Product> _controller =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _products;
  }

  Stream<Product> liveAdded() => _controller.stream;

  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product);
  }
}