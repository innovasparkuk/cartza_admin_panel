import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopease_admin/models/product.dart';
import '../category_model.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  int totalUsers = 0;
  int totalOrders = 0;
  int activeProducts = 0;
  double totalRevenue = 0;

  List<double> salesTrend = [];
  List<int> userGrowth = [];

  List<Map<String, dynamic>> categoryStats = [];
  List<Product> topProducts = [];

  // ✅ Store actual data
  List<CategoryModel> categories = [];
  List<Product> allProducts = [];

  // ✅ UPDATE THIS WITH YOUR BACKEND URL
  // For Android Emulator: http://10.0.2.2:3000/api
  // For Real Device: http://YOUR_IP_ADDRESS:3000/api
  // For Web/Desktop: http://localhost:3000/api
  final String baseUrl = 'http://localhost:3000/api';

  Future<void> loadDashboardData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await Future.wait([
        _fetchCategories(),
        _fetchProducts(),
        _fetchDashboardSummary(),
        _fetchSalesTrend(),
        _fetchUserGrowth(),
        _fetchTopProducts(),
        _fetchCategoryStats(),
      ]);

    } catch (e) {
      error = 'Failed to load dashboard data: $e';
      debugPrint('Dashboard error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ Fetch categories for local calculations
  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        categories = list.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      categories = [];
    }
  }

  // ✅ Fetch all products for local calculations
  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        allProducts = list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      allProducts = [];
    }
  }

  // ✅ NEW: Fetch dashboard summary from backend
  Future<void> _fetchDashboardSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/summary'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        activeProducts = data['activeProducts'] ?? 0;
        totalUsers = data['totalUsers'] ?? 0;
        totalOrders = data['totalOrders'] ?? 0;
        totalRevenue = (data['totalRevenue'] ?? 0).toDouble();
      }
    } catch (e) {
      debugPrint('Error fetching dashboard summary: $e');
    }
  }

  // ✅ NEW: Fetch sales trend from backend
  Future<void> _fetchSalesTrend() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/sales-trend'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        salesTrend = list
            .map<double>((e) => (e['value'] as num).toDouble())
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching sales trend: $e');
      salesTrend = [];
    }
  }

  // ✅ NEW: Fetch user growth from backend
  Future<void> _fetchUserGrowth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/user-growth'),
      );

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        userGrowth = list.map((e) => e['count'] as int).toList();
      }
    } catch (e) {
      debugPrint('Error fetching user growth: $e');
      userGrowth = [];
    }
  }

  // ✅ NEW: Fetch top products from backend
  Future<void> _fetchTopProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/top-products'),
      );

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        topProducts = list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching top products: $e');
      topProducts = [];
    }
  }

  // ✅ NEW: Fetch category stats from backend
  Future<void> _fetchCategoryStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/category-stats'),
      );

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);

        categoryStats = list.map((e) => {
          'label': e['categoryName'] ?? '',
          'value': (e['percentage'] ?? 0).toDouble(),
          'color': _mapColor(e['categoryName'] ?? ''),
          'count': e['count'] ?? 0,
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching category stats: $e');
      categoryStats = [];
    }
  }

  Color _mapColor(String name) {
    // Generate consistent colors based on category name
    final colors = [
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.indigo,
      Colors.red,
      Colors.amber,
      Colors.cyan,
    ];

    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  // ✅ Reload data when categories or products change
  Future<void> refreshData() async {
    await loadDashboardData();
  }
}