import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  // ================= LOAD PRODUCTS =================

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    final data = await ApiService.getProducts();
    _products = data.map<Product>((e) => Product.fromJson(e)).toList();
    _filteredProducts = _products;

    _isLoading = false;
    notifyListeners();
  }

  // ================= ADD PRODUCT =================

  Future<void> addProduct(
      Product product,
      Uint8List? imageBytes,
      BuildContext context,
      ) async {
    _isLoading = true;
    notifyListeners();

    if (imageBytes != null) {
      final imageUrl = await ApiService.uploadImageBytes(imageBytes);
      product.imageUrl = imageUrl;
    }

    final response = await ApiService.addProduct(product.toJson());
    final saved = Product.fromJson(response['product']);

    _products.add(saved);
    filterProducts('', _selectedCategory);

    _isLoading = false;
    notifyListeners();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Product added')));
  }

  // ================= UPDATE PRODUCT =================

  Future<void> updateProduct(
      Product product,
      Uint8List? imageBytes,
      BuildContext context,
      ) async {
    if (imageBytes != null) {
      final imageUrl = await ApiService.uploadImageBytes(imageBytes);
      product.imageUrl = imageUrl;
    }

    final response =
    await ApiService.updateProduct(product.id, product.toJson());

    final updated = Product.fromJson(response['product']);
    final index = _products.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      _products[index] = updated;
    }

    filterProducts('', _selectedCategory);
    notifyListeners();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Product updated')));
  }

  // ================= DELETE PRODUCT =================

  Future<void> deleteProduct(String id, BuildContext context) async {
    _products.removeWhere((p) => p.id == id);
    filterProducts('', _selectedCategory);

    await ApiService.deleteProduct(id);
    notifyListeners();
  }

  // ================= FILTER =================

  void filterProducts(String query, String category) {
    _selectedCategory = category;

    _filteredProducts = _products.where((p) {
      final nameMatch = p.name.toLowerCase().contains(query.toLowerCase());
      final catMatch = category == 'All' || p.category == category;
      return nameMatch && catMatch;
    }).toList();

    notifyListeners();
  }

  // ================= QUICK RESTOCK =================

  Future<void> restockProduct(
      String productId,
      int quantity,
      BuildContext context,
      ) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final product = _products[index];
    final newStock = product.stockQuantity + quantity;

    await ApiService.updateProductStock(productId, newStock);

    product.stockQuantity = newStock;
    _products[index] = product;

    filterProducts('', _selectedCategory);
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock updated')),
    );
  }

  // ================= BULK STOCK UPDATE =================

  Future<void> bulkUpdateStock(
      List<Map<String, dynamic>> updates,
      BuildContext context,
      ) async {
    for (final item in updates) {
      await ApiService.updateProductStock(
        item['productId'],
        item['stock'],
      );

      final index =
      _products.indexWhere((p) => p.id == item['productId']);
      if (index != -1) {
        _products[index].stockQuantity = item['stock'];
      }
    }

    filterProducts('', _selectedCategory);
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All stock updated')),
    );
  }
}
