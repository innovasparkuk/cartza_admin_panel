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

  List<CategoryModel> categories = [];
  List<Product> allProducts = [];

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
        _fetchOrderCount(), // ✅ directly counts real orders
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

  // ✅ Orders page calls this — directly sets count without backend dependency
  void updateOrderCount(int count) {
    totalOrders = count;
    notifyListeners();
  }

  // ✅ Also kept for backward compat — but updateOrderCount is more reliable
  Future<void> refreshOrderCount() async {
    await _fetchDashboardSummary();
    notifyListeners();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        categories = list.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      categories = [];
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        allProducts = list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      allProducts = [];
    }
  }

  Future<void> _fetchDashboardSummary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/summary'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        activeProducts = data['activeProducts'] ?? 0;
        totalUsers = data['totalUsers'] ?? 0;
        totalRevenue = (data['totalRevenue'] ?? 0).toDouble();
        // totalOrders is NOT set here — we fetch it directly from /orders below
      }
    } catch (e) {
      debugPrint('Error fetching dashboard summary: $e');
    }
  }

  // ✅ Always fetch real order count directly from /api/orders
  Future<void> _fetchOrderCount() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        totalOrders = data.length;
      }
    } catch (e) {
      debugPrint('Error fetching order count: $e');
    }
  }

  Future<void> _fetchSalesTrend() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/sales-trend'));
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        salesTrend = list.map<double>((e) => (e['value'] as num).toDouble()).toList();
      }
    } catch (e) {
      debugPrint('Error fetching sales trend: $e');
      salesTrend = [];
    }
  }

  Future<void> _fetchUserGrowth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/user-growth'));
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        userGrowth = list.map((e) => e['count'] as int).toList();
      }
    } catch (e) {
      debugPrint('Error fetching user growth: $e');
      userGrowth = [];
    }
  }

  Future<void> _fetchTopProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/top-products'));
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        topProducts = list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching top products: $e');
      topProducts = [];
    }
  }

  Future<void> _fetchCategoryStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/category-stats'));
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
    final colors = [
      Colors.blue, Colors.pink, Colors.purple, Colors.orange,
      Colors.green, Colors.teal, Colors.indigo, Colors.red,
      Colors.amber, Colors.cyan,
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}