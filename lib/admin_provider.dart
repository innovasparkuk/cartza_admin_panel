// admin_provider.dart
import 'package:flutter/foundation.dart';
 // Import the Product model

class AdminProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;

  // Safe getter that filters out any potential null products
  List<Product> getNonNullProducts() {
    return _products.where((product) => product != null).toList();
  }

  bool get isLoading => _isLoading;

  List<String> get categories {
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    _products = List.generate(20, (index) {
      return Product(
        id: '${index + 1}',
        name: 'Product ${index + 1}',
        description: 'Description for product ${index + 1}',
        price: (index + 1) * 10.0,
        category: ['Electronics', 'Clothing', 'Books', 'Home'][index % 4],
        stockQuantity: 100 - index,
        lowStockThreshold: 10,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now(),
        tags: ['tag1', 'tag2'],
      );
    });

    _filteredProducts = _products;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _products.add(product);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      _applyFilters();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _products.removeWhere((p) => p.id == productId);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> bulkUpdateStock(List<Map<String, dynamic>> updates) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    for (var update in updates) {
      final productId = update['productId'];
      final newStock = update['stock'];
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(
          stockQuantity: newStock,
          // Remove updatedAt from here since it's automatically set in copyWith
        );
      }
    }

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void filterProducts(String query, String category) {
    _searchQuery = query;
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = product.name.toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }
}

extension ProductExtension on Product {
  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    int? stockQuantity,
    int? lowStockThreshold,
    String? imageUrl,
    List<String>? tags,
    Map<String, dynamic>? attributes,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(), // updatedAt is automatically set to now
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
    );
  }
}
// models/product.dart
class Product {
  String id;
  String name;
  String description;
  double price;
  String category;
  int stockQuantity;
  int lowStockThreshold;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> tags;
  Map<String, dynamic>? attributes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    this.lowStockThreshold = 10,
    this.imageUrl = '',
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      stockQuantity: json['stockQuantity'],
      lowStockThreshold: json['lowStockThreshold'] ?? 10,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'attributes': attributes,
    };
  }
}