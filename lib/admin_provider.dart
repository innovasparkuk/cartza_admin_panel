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

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.getProducts();
      _products = data.map<Product>((e) => Product.fromJson(e)).toList();
      _filteredProducts = _products;
      _selectedCategory = 'All';
    } catch (e) {
      debugPrint('Load products error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add new product
  Future<void> addProduct(Product product, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.addProduct(product.toJson());

      if (response['_id'] != null) {
        final savedProduct = Product.fromJson(response);
        _products.add(savedProduct);
        filterProducts('', _selectedCategory);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product "${savedProduct.name}" added!')),
        );
      } else {
      }
    } catch (e) {
      debugPrint('Add product error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update existing product
  Future<void> updateProduct(Product product, BuildContext context) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    final oldProduct = _products[index];
    _products[index] = product;
    filterProducts('', _selectedCategory);

    try {
      await ApiService.updateProduct(product.id, product.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "${product.name}" updated!')),
      );
    } catch (e) {
      _products[index] = oldProduct;
      filterProducts('', _selectedCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update "${product.name}".')),
      );
      debugPrint('Update product error: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String id, BuildContext context) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final removedProduct = _products.removeAt(index);
    filterProducts('', _selectedCategory);

    try {
      await ApiService.deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "${removedProduct.name}" deleted!')),
      );
    } catch (e) {
      _products.insert(index, removedProduct);
      filterProducts('', _selectedCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete "${removedProduct.name}".')),
      );
      debugPrint('Delete product error: $e');
    }
  }

  // Bulk stock update
  Future<void> bulkUpdateStock(List<Map<String, dynamic>> updates) async {
    _isLoading = true;
    notifyListeners();

    try {
      for (final update in updates) {
        final productId = update['productId'];
        final stock = update['stock'];
        await ApiService.updateProductStock(productId, stock);
      }
      await loadProducts();
    } catch (e) {
      debugPrint('Bulk stock update error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Filter products by name & category
  void filterProducts(String query, String category) {
    _selectedCategory = category;
    _filteredProducts = _products.where((p) {
      final matchName = p.name.toLowerCase().contains(query.toLowerCase());
      final matchCat = category == 'All' || p.category == category;
      return matchName && matchCat;
    }).toList();
    notifyListeners();
  }
}
